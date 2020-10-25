+++
author = "Caleb Callaway"
date = 2020-08-19T04:03:10Z
description = ""
draft = false
slug = "confidence-intervals-for-benchmarks"
title = "Confidence Intervals for Benchmarks"

+++


When benchmarking, [confidence intervals](https://www.mathsisfun.com/data/confidence-interval.html) are a standard tool that give us a reliable measure of how much run-to-run variation occurs for a given workload. For example, if I run several iterations of the Bioshock benchmark and score each iteration by recording the average FPS, I might report Bioshock’s average (or [geomean](https://medium.com/@JLMC/understanding-three-simple-statistics-for-data-visualizations-2619dbb3677a)) score as `74.74` FPS with a 99% confidence interval of `0.10`. By reporting this result, I'm predicting that that 99% of Bioshock scores on this platform configuration will fall between 74.64 and 74.84 FPS.

Unless otherwise noted, confidence intervals assume the data is normally distributed:

[![QuaintTidyCockatiel-size_restricted](/blog/content/images/2020/08/QuaintTidyCockatiel-size_restricted.gif)](https://gfycat.com/quainttidycockatiel)

Each pebble in the demonstration represents one benchmark result. Our normal curve may be thiner and taller (or shorter and wider), but the basic shape is the same; most of the results will cluster around the mean, with a few outliers.

Normally distributed data means our 95% confidence interval will be smaller than our 99% confidence interval; 95% of the results will be clustered more closely around the mean value. If our 99% confidence interval is `[74.64, 74.84]`, our 95% interval might be `+/- 0.06`, or `[74.67, 74.80]`. The 100% confidence interval is always `[-infinity, +infinity]`; we’re 100% confident that every measured result will fall somewhere on the number line.

Computing the averages of averages is not always statistically sound, so it may seem incorrect to take the average FPS from each iteration of a benchmark and average them together. In this case we can confidently say that each average has [equal weight](https://math.stackexchange.com/questions/95909/why-is-an-average-of-an-average-usually-incorrect/95912#95912); if not, we need a different benchmark!

Next: [Comparing Benchmark Results](/blog/comparing-confidence-intervals/)

