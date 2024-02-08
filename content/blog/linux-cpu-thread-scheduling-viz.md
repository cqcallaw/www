---
title: "Linux CPU Thread Scheduling Analysis"
date: 2024-02-07T00:00:00-08:00
author: "Caleb Callaway"
draft: false
---

[Heterogeneous CPU topologies](https://www.howtogeek.com/767730/what-are-p-cores-and-e-cores-on-an-intel-cpu/) are becoming commonplace, but how are they utilized [in pratice](https://www.reddit.com/r/linux_gaming/comments/1ag50g1/does_linux_utilize_ecores_like_windows/)? By default, the Linux thread scheduler should schedule work on a P-core until all P-core threads are busy, then start scheduling on E-cores. Perfetto provide a convenient mechanism for visualizing this scheduling policy.

# Thread Topology

[`lstopo`](https://manpages.ubuntu.com/manpages/jammy/man1/lstopo.1.html) provides a useful visual summary of the CPU core topology. As an example, here's the view of my i9-12900KF (AlderLake) CPU with all cores online. Threads 0-15 are the 8 P-cores; two threads for each core because Hyper-Threading is enabled. Threads 16-23 are the E-cores.

[![ADL CPU Core Topology](/blog/content/images/2024/02/07/adl-topo.png)](/blog/content/images/2024/02/07/adl-topo.png)

Cores can be offlined echoing 0 to `/sys/devices/system/cpu/cpuN/online`; offline cores are not present in the `lstopo` visualization.

# Scheduling Visualization

The excellent [Perfetto](https://perfetto.dev/) tool makes it simple to visualize thread scheduling. To visualize the scheduling for the Cyberpunk 2077 benchmark:

1. Build Perfetto: https://perfetto.dev/docs/quickstart/linux-tracing 
3. In a terminal, run tracing command:
```
sudo out/linux/tracebox -o trace_file.perfetto-trace --txt -c test/configs/scheduling.cfg
```
3. In a second terminal, launch the benchmark:
```
steam -applaunch 1091500 --launcher-skip -benchmark
```

Once the benchmark is complete, run `sudo chmod 755 trace_file.perfetto-trace` to make the trace readable by non-root users and open it in the [Perfetto UI](https://ui.perfetto.dev/). Here's an example run:

[![Perfetto Scheduling Viz](/blog/content/images/2024/02/07/perfetto-viz.png)](/blog/content/images/2024/02/07/perfetto-viz.png)

This data shows work evenly distributed across the available CPU threads. This is good, because Cyberpunk is a DX12 game that should leverage multi-threading where possible.

The default trace configuration captures just a few megabytes of data, discarding the rest. This behavior can be modified by [editing the trace configuration](https://perfetto.dev/docs/concepts/config).

# Scheduling Constraints

To constrain the benchmark such that it only runs on P-cores:

```
killall steam && taskset -c 0-15 steam -applaunch 1091500 --launcher-skip -benchmark
```

We must terminate Steam before launching the benchmark; otherwise Steam will signal the current running instance and terminate instead of running the benchmark inside our affinity-constrained environment.
