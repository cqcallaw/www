+++
author = "Caleb Callaway"
date = 2019-05-22T08:13:23Z
description = ""
draft = false
slug = "parallel-computing-use-short-threads"
title = "Parallel Computing: Use Short Threads"

+++


Suppose you have a parallel compute engine capable of executing 64 work items in parallel. Let's also suppose you have work for this compute engine and each individual work item takes 32 seconds to complete.

We can dispatch 2, 5, 18, or 64 such work items to our compute engine and expect the work to complete in roughly 32 seconds, plus some overhead for dispatch and result aggregation. As soon as we dispatch 65 work items, execution time *doubles* from 32 seconds to 64 seconds--more than 1 minute. Not great!

| Work Items  (32 second Runtime) | Runtime (64 Compute Lanes) |
|---------------------------------|----------------------------|
| 2                               | ~32s                       |
| 5                               | ~32s                       |
| 18                              | ~32s                       |
| 64                              | ~32s                       |
| 65                              | ~64s                       |

Let's try again, re-engineering our work items so they do less work but only take 4 seconds to complete. The raw number of computations is the same, so we'll have to dispatch 8x more of the work items. The compute engine's dispatcher will be working harder, but the dispatchers in parallel compute engines are designed for this and should hide the overhead well. From our previous example, 2 work items becomes 16 work items, 5 work items becomes 40, 18 work items goes to 144 work items, and 64 work items becomes 512; 65 work items becomes 520.

16 of our shorter work items now run in about 4 seconds, as does 40 work items. 144 work items run in about 12 seconds; 144 work items * 4 seconds per work item / 64 compute lanes, rounded up to the nearest multiple of 4. 512 work items run in about 32 seconds, so we don't get any speedup for the 64 -> 512 case. 520 work items only take about 36 seconds, compare to the 64 seconds for the 32-second work items. That's almost twice as fast.

| Work Items  (4 second Runtime) | Runtime (64 Compute Lanes) |
|--------------------------------|----------------------------|
| 16                             | ~4s                        |
| 40                             | ~4s                        |
| 144                            | ~12s                       |
| 512                            | ~32s                       |
| 520                            | ~36s                       |

Not all workloads are reducible by 8x, and we can't reduce work item size indefinitely because dispatch costs will eventually dominate running time (the lower bound is orders of magnitude less than 4 seconds), but as a rule of thumb, shorter work items are better for computing in parallel.

