+++
author = "Caleb Callaway"
date = 2020-08-21T06:34:15Z
description = ""
draft = false
slug = "comparing-confidence-intervals"
title = "Benchmark Confidence Interval Part 2: Comparison"

+++


Benchmark data generally isn't interesting in isolation; once we have one data set, we usually gather a second set of data against which the first is compared. Reporting the second result as a percentage of the first result isn't sufficient if we're rigorous and report results with [confidence intervals](/blog/confidence-intervals-for-benchmarks/); we need a more nuanced approach.

Let's suppose we run a benchmark 5 times and record the results, then fix a performance bug and gather a second set of data to measure the improvement. The best  intuition about performance gains is given by scores and confidence intervals that are [normalized](https://en.wikipedia.org/wiki/Normalization_(statistics)) using our baseline geomean score:

<table>
    <tr>
        <th></th>
        <th>Geomean Score</th>
        <th>95% Confidence Interval</th>
        <th>Normalized Score</th>
        <th>Normalized CI</th>
    </tr>
    <tr>
        <th>Baseline</th>
        <td>74.58</td>
        <td>1.41</td>
        <td>100.00%</td>
        <td>1.88%</td>
    </tr>
    <tr>
        <th>Fix</th>
        <td>77.76</td>
        <td>2.92</td>
        <td>104.26%</td>
        <td>3.91%</td>
    </tr>
</table>

All normalization is done using the _same baseline_, even the bug fix confidence interval. One can work out the normalized confidence intervals for a baseline score of `100 +/- 1` and a second score of `2 +/- 1` to see why this must be so.

Now, let's visualize (using a LibreOffice Calc chart with custom [Y error bars](https://help.libreoffice.org/3.3/Chart/Y_Error_Bars)):

![ci-comparison-v1-1](/blog/content/images/2020/08/ci-comparison-v1-1.png)

Woops! The confidence intervals overlap; something's wrong here. We can't be confident our performance optimization will reliably improve the performance of the benchmark unless 95% of our new results fall outside 95% of our old results. Something is dragging down our score and we cannot confidently reject our [null hypothesis](https://en.wikipedia.org/wiki/Null_hypothesis).

The root causes for such negative results are rich and diverse, but for illustrative purposes, let's suppose we missed an edge case in our performance optimization that interacted badly with a power management algorithm. Our intrepid product team has fixed this issue, and now we have:

<table>
    <tr>
        <th></th>
        <th>Geomean Score</th>
        <th>95% Confidence Interval</th>
        <th>Normalized Score</th>
        <th>Normalized CI</th>
    </tr>
    <tr>
        <th>Baseline</th>
        <td>74.58</td>
        <td>1.41</td>
        <td>100.00%</td>
        <td>1.88%</td>
    </tr>
    <tr>
        <th>2nd Fix</th>
        <td>80.18</td>
        <td>1.63</td>
        <td>107.51%</td>
        <td>2.18%</td>
    </tr>
</table>

![ci-comparison-v2](/blog/content/images/2020/08/ci-comparison-v2.png)

Much better; we can confidently reject the null hypothesis and assert that our latest fix has indeed improved performance of this benchmark.

_Many thanks to Felix Degrood for his help in developing my understanding of these concepts and tools_

