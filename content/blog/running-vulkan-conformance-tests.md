+++
author = "Caleb Callaway"
date = 2019-05-06T10:17:16Z
description = ""
draft = false
slug = "running-vulkan-conformance-tests"
title = "Running Vulkan Conformance Tests on Ubuntu 18.04"

+++


A random weekend project, as a series of shell commands:

```
$ sudo apt install cmake libvulkan
$ cd ~/src && git clone https://github.com/KhronosGroup/VK-GL-CTS.git && cd VK-GL-CTS
$ mkdir build && cd build
$ cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64
$ make -j
$ ./deqp-vk --deqp-caselist-file=/home/caleb/src/VK-GL-CTS/external/vulkancts/mustpass/master/vk-default.txt --deqp-log-images=disable --deqp-log-shader-sources=disable --deqp-log-flush=disable
```

