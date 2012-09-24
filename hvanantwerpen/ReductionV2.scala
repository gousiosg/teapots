import scala.annotation.tailrec
import Types._

object ReductionV2 {

    def square(x:Double):Double = x * x
    def sum(x:Double, y:Double):Double = x + y
    def sumOfSquares(xs:List[Double]):Double = xs map( square ) reduceLeft( sum )

    def reduceTriangles(threshold:Double, ts:Triangles) : Triangles = {
        unfoldAcc(threshold, ts, Nil)
    }

    @tailrec def unfoldAcc(threshold:Double, fresh:Triangles, cooked:Triangles) : Triangles = {
	    fresh match {
	        case Nil => cooked
	        case _   => {
	            val reduc = reduceTriangle(threshold)(_)
	            val es = (fresh map( reduc )
	                            flatMap( _ fold( t => List(t), ts => ts ) )
	                            map( transposeT )
	                            map reduc)
	
	            val c = (for ( Left( t ) <- es ) yield transposeT(t))
	            val f = ((for ( Right( t ) <- es ) yield t map transposeT)
	                     flatMap identity)
	
	            unfoldAcc( threshold, f, c ++ cooked )
	        }
	    }
    }

    def reduceTriangle(threshold:Double)(t:Triangle) : Either[Triangle,Triangles] = {
        (for {
            t     <- bigEnough( threshold )( t )
            t     <- noRightEdge( t )
            split <- Some( splitTriangle( t ) )
        } yield split) match {
            case None => Left( t )
            case Some( ts ) => Right( ts )
        }
    }

    def bigEnough(threshold:Double)(t:Triangle) : Option[Triangle] = {
        if ( sumOfSquares(ys(t)) < threshold ) None
        else Some(t)
    }

    def noRightEdge(t:Triangle) : Option[Triangle] = {
        if ( y(t(0)) == y(t(1)) || y(t(1)) == y(t(2)) || y(t(2)) == y(t(0)) ) None
        else Some( t )
    }

    def splitTriangle(t:Triangle) : Triangles = {
        val cs = t sortWith( (c0,c1) => y(c0) < y(c1) || ( y(c0) == y(c1) && x(c0) < x(c1)) )
        val w  = x(cs(0)) - x(cs(2))
        val l  = y(cs(2)) - y(cs(0))
        val b  = y(cs(2)) - y(cs(1))
        val c4 = List( x(cs(2)) + w*(b/l), y(cs(1)) )
        List( cs(0)::cs(1)::c4::Nil, cs(1)::cs(2)::c4::Nil )
    }

}
