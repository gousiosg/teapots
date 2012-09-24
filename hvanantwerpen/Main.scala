import Types._
import Read._
import ReductionV3._
import Plot._

object Main {

    def main(args:Array[String]) : Unit = {
        if ( args.length < 1 ) {
            System.err.println("Usage: Teapot <triangles.txt> [threshold]")
        } else {
            val lines = io.Source.fromFile(args(0)).getLines filter ( ! _.isEmpty )
            val triangles = lines map lineToTriangle toList
            val threshold = if ( args.length > 1 ) {
                args(1).toDouble
            } else {
                val t = guessThreshold( triangles )
                System.out.println("calculated threshold = "+t)
                t
            }
            val reducedTriangles = reduceTriangles(threshold, triangles)
            System.out.println("nTriangles = "+(reducedTriangles length))
            val reducedShapes = reducedTriangles map(createShape)
            val triangleShapes = triangles map(createShape)
            plot(reducedShapes,triangleShapes)
        }
    }

}
