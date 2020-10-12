+++
author = "Caleb Callaway"
date = 2019-05-09T02:45:55Z
description = ""
draft = false
slug = "smart-pointer-copy-performance"
title = "Smart Pointer Copy Performance"

+++


A casual Google search for [smart pointer](https://docs.microsoft.com/en-us/cpp/cpp/smart-pointers-modern-cpp?view=vs-2019) performance yields [analysis of shared vs. "raw" pointers](http://blog.davidecoppola.com/2016/10/performance-of-raw-pointers-vs-smart-pointers-in-cpp/), which concludes that there is no appreciable performance penalty for using smart pointers. The access, allocation, and deallocation findings seem reasonable; the data supports the use of [std::make_shared](https://en.cppreference.com/w/cpp/memory/shared_ptr/make_shared) for best performance.

I'm not convinced by the copy results, however; the atomic operations required to increment and decrement ref counts on shared pointers are expensive (see https://stackoverflow.com/a/2783981/577298 and https://htor.inf.ethz.ch/publications/img/atomic-bench.pdf).

To support my skepticism, I've written a small benchmark that measures the performance of raw pointers passed to iterative and recursive increment functions. The same tests are then repeated with smart pointers. This benchmark is designed to mimic the existing test and also simulate a deeply nested call stacks in which smart pointers seem to shine because it's difficult to reason about resource lifetime.

Results:

```
Raw iterative ops: 8192
Raw iterative test repetitions: 16384
Raw iterative results:
        Min: 795 ns (0.0970459 ns per op)
        Max: 53083 ns (6.47986 ns per op)
        Average: 1285.32 ns (0.156899 ns per op)

Raw recursion ops: 8192
Raw recursion test repetitions: 16384
Raw recursive results:
        Min: 794 ns (0.0969238 ns per op)
        Max: 20638 ns (2.51929 ns per op)
        Average: 863.515 ns (0.10541 ns per op)

SP iterative ops: 8192
SP iterative test repetitions: 16384
SP iterative results:
        Min: 12301 ns (1.50159 ns per op)
        Max: 44715 ns (5.45837 ns per op)
        Average: 12627.1 ns (1.54139 ns per op)

SP recursion ops: 8192
SP recursion test repetitions: 16384
SP recursive results:
        Min: 27654 ns (3.37573 ns per op)
        Max: 110610 ns (13.5022 ns per op)
        Average: 29545.5 ns (3.60663 ns per op)
```

Compiled with GCC 7.4.0 using the same compiler flags as the existing data (`-O3 -s -Wall -std=c++11`) and tested on Ubuntu 18.04 with an i7-6900K CPU @ 3.20GHz and 64 GB of memory.

Smart pointers are significantly slower than raw pointers for both tests; disabling compiler optimizations (`-O0`) makes the delta between raw and SP performance even more obvious:

```
Raw iterative ops: 8192
Raw iterative test repetitions: 16384
Raw iterative results:
        Min: 18687 ns (2.28113 ns per op)
        Max: 100941 ns (12.3219 ns per op)
        Average: 22257 ns (2.71691 ns per op)

Raw recursion ops: 8192
Raw recursion test repetitions: 16384
Raw recursive results:
        Min: 29396 ns (3.58838 ns per op)
        Max: 115340 ns (14.0796 ns per op)
        Average: 31549.7 ns (3.85128 ns per op)

SP iterative ops: 8192
SP iterative test repetitions: 16384
SP iterative results:
        Min: 312024 ns (38.0889 ns per op)
        Max: 510200 ns (62.2803 ns per op)
        Average: 362119 ns (44.2039 ns per op)

SP recursion ops: 8192
SP recursion test repetitions: 16384
SP recursive results:
        Min: 410023 ns (50.0516 ns per op)
        Max: 576959 ns (70.4296 ns per op)
        Average: 414347 ns (50.5795 ns per op)
```

[My code is available](https://github.com/cqcallaw/sp-benchmark)

*Thanks to Rafael Barbalho for inspiring this experiment and to Matthew Lawson for proofreading and feedback*

