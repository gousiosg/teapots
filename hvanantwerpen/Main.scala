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
            val t0 = System.currentTimeMillis
            val reducedTriangles = reduceTriangles(threshold, triangles)
            val dt = System.currentTimeMillis-t0
            System.out.println("nTriangles = "+(reducedTriangles length)+" in "+(dt/1000.0)+"s")
            val reducedShapes = reducedTriangles map(createShape)
            val triangleShapes = triangles map(createShape)
            plot(reducedShapes,triangleShapes)
        }
    }

    def guessThreshold(ts:Triangles) : Double = {
		val minX = ts flatMap( xs ) reduceLeft( _ min _ )
		val minY = ts flatMap( ys ) reduceLeft( _ min _ )
		val maxX = ts flatMap( xs ) reduceLeft( _ max _ )
		val maxY = ts flatMap( ys ) reduceLeft( _ max _ )
		( ( maxX - minX ) min ( maxY - minY ) ) / 1000.0
    }
    
}
