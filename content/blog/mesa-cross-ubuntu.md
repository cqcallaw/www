---
title: "Cross-compiling Mesa on Ubuntu"
date: 2023-08-13T10:39:11-07:00
draft: false
author: "Caleb Callaway"
tags: ["tech", "linux", "gaming"]
---

Bisecting Mesa on Ubuntu isn't as straight-forward as my previous [post]({{< ref "/blog/mesa-bisection-build" >}}) might suggest. Most modern workloads use 64-bit binaries, but Steam [still requires 32-bit libraries](https://steamcommunity.com/app/221410/discussions/0/3267935171633666595/) and game managers like Uplay frequently carry similar requirements. Deploying different builds of Mesa for 64- and 32-bit often leads to workload instability.

Cross-compilng Mesa on Ubuntu is a bit fraught, however. Until recently, one needed to install the 32-bit valgrind package to build 32-bit Mesa, which forced the 64-bit valgrind package to be uninstalled. As of this writing, Mesa requires LLVM 15, and installing the 32bit version of LLVM 15 on Ubuntu 22.04 will remove key packages like `ubuntu-desktop` and `xorg`. If in ignorance one uses apt's `-y` option, sadness ensues.

These considerations render Mesa's [standard cross-compilation method](https://docs.mesa3d.org/meson.html#cross-compilation-and-32-bit-builds) ill-suited to Ubuntu. There is, however, an alternative approach that utilizes [schroot](https://wiki.debian.org/Schroot), which enables us to provision build environments inside [chroots](https://wiki.debian.org/chroot), much like a Python [venv](https://docs.python.org/3/library/venv.html). The following script illustrates the technique.


```
#!/bin/sh

set -e # terminate on errors
set -x # echo commands

BUILD_OPTS="-Dglvnd=true"
SRC_DIR=$HOME/src/mesa

CODENAME=$(lsb_release --codename --short)
# make sure source is available
if [ ! -d "$SRC_DIR" ]; then
    mkdir -p $SRC_DIR
fi

set +e # allow errors temporarily
git -C $SRC_DIR rev-parse 2>/dev/null
exit_code=$(echo $?)
set -e
if [ "$exit_code" -ne 0 ] ; then
    echo "Cloning source..."
    # checkout source
    git clone https://gitlab.freedesktop.org/mesa/mesa.git $SRC_DIR
else
    echo "Source already cloned."
fi

# configure execution-wide state
BUILD_ID=`git -C $SRC_DIR describe --always --tags`
INSTALL_DIR=/usr/local-$BUILD_ID

build_mesa() {
	# $1: The schroot architecure
	# $2: The name of the schroot environment
	# $3: The schroot personality
	# ref: https://unix.stackexchange.com/questions/12956/how-do-i-run-32-bit-programs-on-a-64-bit-debian-ubuntu
	SCHROOT_PATH="/build/$CODENAME/$1"
	
	sudo apt -y install schroot debootstrap
	sudo mkdir -p $SCHROOT_PATH

	echo "Bootstrapping environment..."
	set +e # debootstrap will return non-zero if the environment has been previously provisioned
	sudo debootstrap --arch $1 $CODENAME $SCHROOT_PATH http://archive.ubuntu.com/ubuntu
	set -e

	echo "Configuring apt..."
	# create minimum viable apt sources
	# ref: https://stackoverflow.com/questions/17487872/shell-writing-many-lines-in-a-file-as-sudo
	sudo sh -c "cat > $SCHROOT_PATH/etc/apt/sources.list" << EOF
deb http://archive.ubuntu.com/ubuntu $CODENAME universe restricted main multiverse
deb http://archive.ubuntu.com/ubuntu ${CODENAME}-updates universe restricted main multiverse
deb http://archive.ubuntu.com/ubuntu ${CODENAME}-backports universe restricted main multiverse
deb http://archive.ubuntu.com/ubuntu ${CODENAME}-security universe restricted main multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ $CODENAME universe restricted main multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates universe restricted main multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-backports universe restricted main multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-security universe restricted main multiverse
EOF

	echo "Configuring chroot..."
	sudo sh -c "cat > /etc/schroot/chroot.d/$2" << EOF
[$2]
description=64b Mesa Build Env
directory=$SCHROOT_PATH
type=directory
personality=$3
groups=users,admin,sudo
EOF

	sudo schroot -c $2 apt update
	# "-- sh -c" required to pass arguments to chroot correctly
	# ref: https://stackoverflow.com/a/3074544
	sudo schroot -c $2 -- sh -c "apt -y --fix-broken install" # sometimes required for initial setup
	sudo schroot -c $2 -- sh -c "apt -y upgrade"
	sudo schroot -c $2 -- sh -c "apt -y build-dep mesa"
	sudo schroot -c $2 -- sh -c "apt -y install git llvm llvm-15"

	# Contemporary Mesa requires LLVM 15. Make sure it's available
	sudo schroot -c $2 -- sh -c "update-alternatives --install /usr/bin/llvm-config llvm-config /usr/lib/llvm-15/bin/llvm-config 200"

	# do the build
	cd $SRC_DIR
	BUILD_DIR=build-$BUILD_ID/$1
	mkdir -p $BUILD_DIR
	sudo schroot -c $2 -- sh -c "meson setup $BUILD_DIR $BUILD_OPTS --prefix=$INSTALL_DIR"
	sudo schroot -c $2 -- sh -c "ninja -C $BUILD_DIR"
	sudo schroot -c $2 -- sh -c "ninja -C $BUILD_DIR install"

	# deploy
	sudo cp -Tvr "${SCHROOT_PATH}${INSTALL_DIR}" "$INSTALL_DIR"
}

build_mesa "amd64" "${CODENAME}64" "linux"
build_mesa "i386" "${CODENAME}32" "linux32"

}

build_mesa "amd64" "${CODENAME}64" "linux"
build_mesa "i386" "${CODENAME}32" "linux32"
```

As before, environment overrides are required for system components to use the new build. Both 64-bit and 32-bit overrides are necessary.

```
# Force use of the local Mesa build for GL workloads
LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/:/usr/local/lib/i386-linux-gnu/:$LD_LIBRARY_PATH
LIBGL_DRIVERS_PATH=/usr/local/lib/x86_64-linux-gnu/dri:/usr/local/lib/i386-linux-gnu/dri:$LIBGL_DRIVERS_PATH

# Here I force the use of local the local build for Intel GPUs--revise as needed
# Newer versions of the Vulkan Loader should make this simpler;
# see https://github.com/KhronosGroup/Vulkan-Loader/pull/1274
VK_ICD_FILENAMES=/usr/local/share/vulkan/icd.d/intel_icd.x86_64.json:/usr/local/share/vulkan/icd.d/intel_icd.i686.json
```

Also as before, the new build must be deployed to `/usr/local` (in a shell that sources the new environment):

```
sudo service gdm3 stop
sudo ln -sfn /usr/local-`git describe --always --tags` /usr/local
sudo ldconfig # update linker cache
sudo service gdm3 start
```

I expect this script to evolve over time, so I've committed it to [GitHub](https://github.com/cqcallaw/mesa-builder).
