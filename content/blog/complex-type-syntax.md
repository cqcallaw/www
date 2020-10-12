+++
author = "Caleb Callaway"
date = 2016-04-25T01:23:42Z
description = ""
draft = false
slug = "complex-type-syntax"
title = "New Complex Type Syntax"

+++


As part of the on-going build-out of recursive types in newt, complex types have been re-worked such that every complex type is a dictionary of type declarations (previously, record types were a dictionary of _values_, with special logic to generate modified copies of this dictionary). In this new model, type declarations that reference existing types are implemented as type _aliases_. Thus, in the following type declaration, `person.age` is an alias for `int`, `person.name` is an un-aliased record type, and `person.name.first` and `person.name.last` both alias the built-in type `string`.

```
person {
   age:int,
   name {
        first:string,
        last:string       
   }
}
```

For purposes of assignment and conversion, a type alias is directly equivalent to the type it aliases.

The `struct` keyword is noteworthily absent from the previous record type definition, and there are now commas separating type members. These are not accidents, as the re-worked type declarations allow for arbitrarily nested type definitions, and repeated use of the `struct` and `sum` keywords felt heavy and inelegant. For this (primarily aesthetic) reason, the keywords are omitted from the nested types, and to maintain a uniform, non-astonishing grammar, the keyword is omitted from the top-level complex type declarations as well.

Omission of the keywords requires another mechanism for differentiating sum and product types, however, so members of record types must now be comma-delimited, while sum type variants are delimited by a vertical bar (that is, a pipe). In this new syntax, a linked list of integers might be expressed as follows:

```
list {
	end
	| item {
		data:int,
		next:list
	}
}
```
The new syntax very closely matches the [proposed syntax for map literals](https://github.com/cqcallaw/newt/issues/11), which is a nice isomorphism, but does raise concerns about legibility issues. Time will tell.

