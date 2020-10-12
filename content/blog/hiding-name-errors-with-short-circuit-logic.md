+++
author = "Caleb Callaway"
date = 2017-05-12T09:01:35Z
description = ""
draft = false
slug = "hiding-name-errors-with-short-circuit-logic"
title = "Hiding name errors with short-circuit logic"

+++


A simple Python program:

```
flag1 = False
flag2 = True
if False:
  nested_flag = False

# No NameError here!  
if flag1 and nested_flag:
  print('Stuff!')
else:
  print('No Stuff!')

#Causes a NameError
if flag2 and nested_flag:
  print('Stuff Again!')
else:
  print('No Stuff Again!')
```

Sample output:
```
Python 3.5.2 (default, Dec 2015, 13:05:11)
[GCC 4.8.2] on linux
   
No Stuff!
Traceback (most recent call last):
  File "python", line 11, in <module>
NameError: name 'nested_flag' is not defined
```

The first conditional does not cause a NameError, presumably because the Python interpreter doesn't evaluate the second operand of the Boolean `AND` operation if the first operand evaluates to False. This is a reasonable optimization, but omitting all processing of the second operand hides the name error until very specific runtime conditions are met. In production code, the state of `flag1` may only be true 1% of the time or depend on user interactions or database reads, so this class of errors can be very difficult to catch, even with a well-designed test plan.

The solution is simple: analyse the code for semantic correctness--including name errors--before the code ever runs. Fail early, fail fast.

