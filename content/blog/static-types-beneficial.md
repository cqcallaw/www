+++
author = "Caleb Callaway"
date = 2019-02-17T02:23:09Z
description = ""
draft = false
slug = "static-types-beneficial"
title = "Static Type Checking Considered Beneficial"

+++


Reliance on runtime type checking places the burden of type checking on fallible, stressed, distracted human beings in much the same way that [manual memory management](https://en.wikipedia.org/wiki/Manual_memory_management) does. It's easy to believe that elitism plays a role too ("*real* programmers don't need type checking tools..."). Writing a leak-free program is *possible* without automated leak checks, and it's certainly *possible* to write type-correct code without automated type checks, but the chances of success are extraordinarily low and the cognitive load grows exponentially with the size of the code base.

For these reasons, I'm supremely disappointed by this section of [Python's type hints enhancement](https://www.python.org/dev/peps/pep-0484/#rationale-and-goals):

> It should also be emphasized that **Python will remain a dynamically typed language, and the authors have no desire to ever make type hints mandatory, even by convention.**

I like a lot of things about Python, but this isn't one of them. Many hours of over-confident developer time could have been saved, particularly for novices who might not be savvy enough to seek out tools like [MyPy](http://mypy-lang.org/index.html).

