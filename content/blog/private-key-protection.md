+++
author = "Caleb Callaway"
categories = ["security"]
date = 2016-02-17T06:13:54Z
description = ""
draft = false
slug = "private-key-protection"
tags = ["security"]
title = "Private Key Protection"

+++


Obtaining access to an unencrypted copy of one's private key completely compromises the security of key-based SSH authentication, so the security of one's private key is foundational to securing this form of authentication. 

Private keys are commonly secured with a password-based encryption, but for some years now I have used a more physical means of securing access: my private key is stored on an encrypted flash drive which lives on my physical keyring and is detached from the computer when not in use. The private key is [symlinked](https://en.wikipedia.org/wiki/Symbolic_link) from a local folder so that it is not necessary to specify the identify file each time an SSH session is initiated. This configuration has the following advantages:

* Enables transportation of a single private key between multiple workstations or laptops. Untrusted hosts will not be able to decrypt the flash drive without the passphrase.
* Disk encryption key can be very long and difficult to crack, mitigating the risk of compromise in the event of a stolen or lost USB key, and providing an additional layer of encryption that must be broken to access the private key.
* Theft of the flash drive is easily discovered, but recovering from theft does require one to store a duplicate flash drive in a secure location.

#Howto
This guide is written for Ubuntu 14.04 LTS, where encryption of external drives is trivial. The guide likely applies to other Linux distributions as well.

1. Obtain a USB flash drive. The drive should be compact and easily attached to a physical keyring; something like the [LaCie PetiteKey](http://www.lacie.com/products/usb-keys/petitekey/) works well.

2. Generate a secure disk encryption passphrase with [pwgen](http://manpages.ubuntu.com/manpages/trusty/man1/pwgen.1.html). You will need this passphrase for each computer on which you wish to use the private key.

3. Encrypt the USB flash drive. There are [many](https://help.ubuntu.com/community/EncryptedFilesystemsOnRemovableStorage) [tutorials](http://www.makeuseof.com/tag/create-secure-usb-drive-ubuntu-linux-unified-key-setup/) for this. I recommend giving the encrypted volume a meaningful name like `secure-key`.

 It's considered less secure to have the computer remember the encryption passphrase, but I recommend doing so if you directly control the computer. Remembering the encryption passphrase allows you to specify a longer, more secure passphrase than what you could reasonably enter by hand, and makes the process of activating key-based authentication much more streamlined and usable.

4. In a [terminal](https://help.ubuntu.com/community/UsingTheTerminal), create a `.ssh` folder on the flash drive. In Ubuntu, this mount point will be `/media/<username>/<disk_label>`:

        $ mkdir /media/caleb/secure-key/.ssh

5. Fix the directory permissions of the `.ssh` folder:

        $ chmod -R 0700 /media/caleb/secure-key/.ssh

6. In a terminal, symlink your user's local `.ssh` folder to the `.ssh` folder on the encrypted flash drive:

        $ ln -sf /media/caleb/secure-key/.ssh /home/caleb/.ssh

 If you already have an existing `.ssh` folder with contents you wish to keep, simply rename the folder and move its contents after creating the symlink.

7. Generate an SSH key if you don't already have one:

        $ ssh-keygen -t rsa

 Be sure to specify a strong passphrase when prompted to do so. I do not recommend caching this passphrase.

8. Verify the key exists on your flash drive:

        $ ls -al /media/caleb/secure-key/.ssh
        -rw-------  1 caleb caleb   751 Dec  4  2011 id_dsa
        -rw-r--r--  1 caleb caleb   610 Apr 19  2010 id_dsa.pub
        -rw-------  1 caleb caleb  1766 Aug  4  2011 id_rsa
        -rw-r--r--  1 caleb caleb   410 Oct 22  2010 id_rsa.pub

 If all is well, you now have a physical layer of security for your SSH key.

9. (Optional, but strongly recommended) [Make a backup](http://askubuntu.com/questions/318893/how-do-i-create-a-bit-identical-image-of-a-usb-stick) of the flash drive in case your primary key is lost or stolen.

#Usage
To disable key-based authentication, simply remove the USB flash drive (safely or otherwise) and attach it to your key chain. To re-enable key-based authentication, re-attach the USB flash drive. You should be prompted for the disk-level encryption passphrase unless you elected to have your computer remember the encryption passphrase.

#Environment Tweaks
Alternative windows managers may require some magic to automatically mount the encrypted flash drive. For instance, when using Gnome together with Xmonad, one must add the following line to `/usr/share/gnome-session/sessions/xmonad.session`

        ...
        DesktopName=Unity

However, doing so will cause another issue where the battery indicator will no longer be displayed. To get the battery indicator back, remove or disable the line `NotShowIn=Unity;` in the file `/etc/xdg/autostart/indicator-power.desktop`.

