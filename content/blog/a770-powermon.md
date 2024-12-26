---
author: "Caleb Callaway"
title: "A770 Power Monitoring"
date: 2024-12-12T16:30:54-08:00
draft: false
---

**Update**: just use [qmassa](https://github.com/ulissesf/qmassa) instead.

I was unable to dump power usage for my Intel Alchemist card using standard tools (lm-sensors, powerstat), but a bit of Python does the trick:

```
import time

p = '/sys/class/drm/card0/device/hwmon/hwmon4/energy1_input'

def read_energy(path: str) -> int:
    with open(path, "r") as f:
        energy = int(f.read().strip())
        return energy

sample = read_energy(p)
previous_sample = sample

ts = time.time_ns()
while(True):
    previous_sample = sample
    sample = read_energy(p)

    previous_ts = ts
    ts = time.time_ns()

    # energy reports are in uJoules
    # ref: https://www.kernel.org/doc/Documentation/hwmon/sysfs-interface
    energy_delta_uj = sample - previous_sample
    time_delta_ns = ts - previous_ts
    energy_delta_j = energy_delta_uj / 1000000
    time_delta_s = time_delta_ns / 1000000000
    # power = energy per second
    watts = round(energy_delta_j / time_delta_s, 2)

    print(f"{watts}W")
    time.sleep(0.5)
```