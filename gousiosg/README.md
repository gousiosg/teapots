Teapot - Scala implemenation
=============================

Description
-----------

The approach to solving the problem is based on [Analytic
Geometry](http://en.wikipedia.org/wiki/Analytic_geometry).  The basic idea is
that in an non-right triangle there can be only one vertical or horizontal
line that crosses a vertex and an edge at the same time. Therefore, to
decompose an arbitrary triangle to a set of right triangles, what we need to do is draw horizontal or vertical lines that pass through each triangle vertex
and extend to the triangle's bounding box. Using analytical geometry, we can
calculate the point D where one of those lines crosses the triangle's vertex and we know already that the vertex (i.e. B). If we know the coordinates of this point and those of the original triangle vertices (i.e. A,B,C), we can split the triangle as follows.

```
tr1 = A, B, D
tr2 = C, B, D
```

We then continue the splitting recursively, alternating at each step the
direction of the introduced crosslines, until the area of the triangle is
too small to be displayed or until we reach to a right triangle.

Running
-------

```
scalac Teapot.scala 
scala Main ../teapot.txt
```

Output
------
<img src="https://github.com/gousiosg/teapots/blob/master/gousiosg/teapot.png?raw=true"/>

