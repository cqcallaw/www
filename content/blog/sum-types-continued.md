+++
author = "Caleb Callaway"
categories = ["newt"]
date = 2016-02-01T09:36:28Z
description = ""
draft = false
slug = "sum-types-continued"
tags = ["newt"]
title = "Sum Types, continued"

+++


Regarding [yesterday's post about sum types](/blog/sum-types-structural-vs-nominal/), co-conspirator Lao observed that the verbosity of structural sum types could be overcome by allowing structural sum types to be aliased, e.g.:
```
sum number {
    int
    | double
}

t:number = 7
```

Another issue raised by co-conspirator Lao is the interaction of using widening conversions and function overloads. For example:
```
# declare an overloaded function
f:= {
    ((int|double)) -> unit {}
    & ((int|string)) -> unit {}
}

f(7) # invocation is compatible with both overloads
```
Using type aliases does not address this ambiguity, since the integer argument can be widened to either type. It appears necessary to declare this particular invocation ambiguous, and require the programmer to explicitly widen the argument to the appropriate type. Attempting to widen to the "widest" conversion seems complicated and error-prone.

It has also been observed that sum types are a collection of _types_, not symbols, and thus distinct from namespaces, which can contain both types and symbols.

Finally, if record types (i.e. structs) without members are permitted, enums could be expressed as an aliased structural sum type. Ideally, the empty struct members would be namespaced such that the surrounding namespace was not polluted.

