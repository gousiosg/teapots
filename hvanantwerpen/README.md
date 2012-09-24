Teapot - Yet another Scala implementation
=========================================

Per request, three versions are included to show how the code
developed. The last version is run, but this can be changed by changing
the import in Main.scala.

Interesting observation (#triangles ~ 237k):

<table>
    <tr><td>Version</td><td>#lines</td><td>runtime (s)</td></tr>
    <tr><td>ReductionV1</td><td>43</td><td>30.64</td></tr>
    <tr><td>ReductionV2</td><td>63</td><td>3.11</td></tr>
    <tr><td>ReductionV3</td><td>71</td><td>2.78</td></tr>
</table>

Description
-----------

The actual splitTriangle function is very simple. It sorts the traingle
points by y and project the middle point on the line between the two
others. This function is used for both directions, by transposing the
coordinates of the argument and the results.

The function reduceRightToLeft contains the recursion logic. It calls
a function on every element of the input, but the function can return
either new input elements or a result. The results are returned in a
list when all input elements (original and later ones) are processed.
The function currently implements a depth-first recursion, so the
sub-triangles of a triangle will stay in the same relative position in
the list. This was because if the order is not maintained, triangles of
the back and the front of the teapot will mix, resulting in a strange
visual effect.

The reduceTriangle2D and reduceTriangle1D use for-comprehension (Scala
equiv. of Haskell's do-notation) over Eithers and Options repectivily. In
the latter case the options are used to make sure the split only happens
if the triangle is big enough and does not already have a straight
edge. Wether the triangle was split or not, is indicated by returning
the original in Left or the new ones in Right. The reduceTriangle2D
uses this in it's own for-comprehension, where the next calculation
is only executed when the previous didn't split. If both didn't split,
the result is returned, otherwise the split triangles will be returned
as inputs for a later iteration.

Plotting is done with the Swing and the Java2D API.

Running
-------

Compile with

    scalac Types.scala Read.scala Plot.scala ReductionV1.scala ReductionV2.scala ReductionV3.scala Main.scala

Then run with

    scala -cp . Main ../teapot.txt

or, if you want a higher threshold (i.e. less triangles), with

    scala -cp . Main ../teapot.txt 0.5

If you want to run ReductionV1, increase the stack size with

    scala -J-Xss1024m -cp . Main ../teapot.txt

Instead of all this, you can also use {build,run}.sh scripts.

Output
------

<img src="https://github.com/hendrikvanantwerpen/teapots/blob/master/hvanantwerpen/Teapot.png?raw=true"/>
