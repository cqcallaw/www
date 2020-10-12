+++
author = "Caleb Callaway"
date = 2019-02-15T10:46:35Z
description = ""
draft = false
slug = "sequence-to-coordinates"
title = "Sequence to Coordinates"

+++


I've encountered problems at work and in interviews can be reduced to a problem of translating a integer value (0, 1, 2, 3...n) into [2D coordinates](https://en.wikipedia.org/wiki/Two-dimensional_space). Iterative approaches usually aren't applicable because one generally gets a single sequence number without a loop context. For example, it's often necessary to map an OpenCL work item (identified by an [integer ID](https://www.khronos.org/registry/OpenCL/sdk/1.0/docs/man/xhtml/get_global_id.html)) to a region of the image on which the work item will operate.

To solve this, one needs to know the width and height of the coordinate space, and the walk direction. For a horizatonal walk, X values increase first: (0,0) (1,0) (2,0) (3,0) etc; for a vertical walk, Y values increase first: (0,0) (0,1) (0,2) (0,3) and so forth.

I solve this as follows: the coordinate that corresponds to the walk dimension is computed by taking the sequence number [modulo](https://en.wikipedia.org/wiki/Modulo_operation) the maximum walk value (that is, the height or width). The other component is the [integer division](https://en.wikipedia.org/wiki/Division_(mathematics)#Of_integers) of the sequence number and the maximum walk value.

More concretely, the X coordinate for a horizontal walk is the integer sequence number modulo the width of the coordinate space, and Y coodinate is the sequence number integer divided by the width of the coordinate space. For a vertical walk, the X coordinate is the sequence number integer divided by the height of the coordinate space; the Y coordinate is the sequence number modulo the height of the coordinate space.

Python 3 code:

```
def horizontal_walk(total_coords, width):
	return [(i % width, int(i / width)) for i in range(total_coords)]

def vertical_walk(total_coords, height):
	return [(int(i / height), i % height) for i in range(total_coords)]
```

