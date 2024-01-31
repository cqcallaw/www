---
author: "Caleb Callaway"
title: "PCI-E Link Speed in Linux"
date: 2024-01-30T17:27:46-08:00
draft: false
---

My Alchemist 770 GPU supports PCI-E Gen4 x16, but `lspci`` reports it as a Gen1 x1 device:

```
$ sudo lspci -vvv -s 03:00.0 | grep LnkCap:
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
```

However, the full link width and speed is reported by the PCI bridge:

```
$ sudo lspci -vvv -s 01:00.0 | grep LnkCap:
		LnkCap:	Port #0, Speed 16GT/s, Width x16, ASPM L1, Exit Latency L1 <64us
```

The ID of the bridge to which the GPU is connected can be found by examining the PCI-E topology:

```
$ sudo lspci -vvnn -t
-[0000:00]-+-00.0  Intel Corporation Device [8086:4660]
           +-01.0-[01-04]----00.0-[02-04]--+-01.0-[03]----00.0  Intel Corporation Device [8086:56a0]
           |                               \-04.0-[04]----00.0  Intel Corporation Device [8086:4f90]
...
```