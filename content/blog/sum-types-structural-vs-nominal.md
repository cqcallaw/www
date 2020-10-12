+++
author = "Caleb Callaway"
categories = ["newt"]
date = 2016-01-31T05:56:54Z
description = ""
draft = false
slug = "sum-types-structural-vs-nominal"
tags = ["newt"]
title = "Sum Types: Nominal vs. Structural"

+++


[newt](https://github.com/cqcallaw/newt/) is strongly influenced by functional programming languages, so it's no accident that many of the language constructs are copied or adapted from functional programming. No existing paradigm is sacrosanct, however, so even the implementation of classic FP constructs should be considered carefully.

One recent and long-running  design discussions is centered around the implementation of sum types (i.e. [tagged unions](https://en.wikipedia.org/wiki/Tagged_union)). This type-safe and succinct method for describing a value that is one of several variants is well-aligned with the language design goals. The common implementation of sum types identifies the variants of the type with a _tag_, which is simply a name for one of the variants. This makes the sum type a _nominal_ type, where equivalence is determined by the name. Rust's [enums](https://doc.rust-lang.org/book/enums.html) are a fine example of this nominal approach:

```
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}
```

This snippet defines a Message type that can be a Quit message with no associated data, a ChangeColor message that contains a tuple of integers representing RGB color value, a Move message with associated Cartesian coordinates, or a Write message with an associated string value. Instances are created with a type constructor as follows:

```
let x: Message = Message::Move { x: 3, y: 4 };
```

To use a value of a sum type, the specific variant is [matched by name](https://doc.rust-lang.org/book/match.html#matching-on-enums) before use:

    match msg {
        Message::Quit => quit(),
        Message::ChangeColor(r, g, b) => change_color(r, g, b),
        Message::Move { x: x, y: y } => move_cursor(x, y),
        Message::Write(s) => println!("{}", s),
    };

Performing computations with values of a sum type without first performing a `match` decomposition is usually a semantic error. For example, adding to values of type `Message` together is nonsensical, but adding two values of type `Message::Move` could be interpreted as vector addition.

So far the construct is regular and coherent (although I strongly disagree with the use of the keyword `enum`), but the syntax feels a bit heavy for simple cases. For many simple sum types (such as the Message example from Rust), the variants are each of different types, and can be matched by the _structure_ of the type instead of its name. In small examples, the gains in succinctness can be significant, as illustrated by the following hypothetical newt snippets:

```
# nominal approach
sum number {
	discrete:int
	| continuous:double
}
t:= number::discrete(7)
```

```
# structural approach
t:(int|double)= 7
```
This succinctness is offset by verbosity when specifying struct members or function return types:

```
# nominal
f:= (a:int) -> number { }
f:= (a:double) -> number { }
```
```
# structural
f:= (a:int) -> (int|double) { }
f:= (a:double) -> (int|double) { }
```

The verbosity increases with each additional structural variant. Type inference solves the double verbosity of function return types and variable types, but does not address the verbosity of multiple function definitions with the same return type.

Even so, the nominal typing still feels verbose. My current thinking is to require nominal typing, but allow type inference of the variant where possible. For example, the `int` variant can unambiguously be inferred as follows:

```
sum number {
	discrete:int
	| continuous:double
}
t:number= 7 # t will be of type number::discrete
```

