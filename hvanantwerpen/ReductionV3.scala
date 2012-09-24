import scala.annotation.tailrec
import Types._

object ReductionV3 {

    def square(x:Double):Double = x * x
    def sum(x:Double, y:Double):Double = x + y
    def sumOfSquares(xs:List[Double]):Double = xs map( square ) reduceLeft( sum )
    
    def reduceRightToLeft[A,B]( f:A => Either[B,List[A]], init:List[A] ) : List[B] = {
        @tailrec def acc(as:List[A], bs:List[B]) : List[B] = {
            as match {
                case Nil   => bs reverse
                case e::es => {
                    val (nextAs,nextBs) = f(e) match {
                        case Left( newB )  => (es, newB :: bs)
                        case Right( newAs ) => (newAs ++ es, bs)
                    }
                    acc(nextAs, nextBs)
                }
            }
        }      
        acc(init,Nil)
    }
    
    def reduceTriangles(threshold:Double, ts:Triangles) : Triangles = {
        reduceRightToLeft[Triangle,Triangle]( reduceTriangle2D(threshold)(_), ts )
    }
    
    def reduceTriangle2D(threshold:Double)(t:Triangle) : Either[Triangle,Triangles] = {
        (for {
            e <- ( reduceTriangle1D( threshold )( t )
                   left )
            e <- ( reduceTriangle1D( threshold )( transposeT( e ) )
                   fold( l => Left( transposeT( l ) ), 
                         rs => Right( rs map( transposeT ) ) )
                   left )
        } yield e)
    }
    
    def reduceTriangle1D(threshold:Double)(t:Triangle) : Either[Triangle,Triangles] = {
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
