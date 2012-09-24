import scala.io.Source
import scala.util.matching.Regex
import Types._

object Read {

    val TReg = """"\{(.+),\s*(.+)\}","\{(.+),\s*(.+)\}","\{(.+),\s*(.+)\}"""".r
    
    def readTriangles(f:String) : Triangles = {
        (Source.fromFile( f ).getLines
         filter( ! _.isEmpty )
         map( lineToTriangle )
         toList)
    }

    def lineToTriangle(l:String) : Triangle = {
        val TReg(x1,y1,x2,y2,x3,y3) = l
        ( List( x1::y1::Nil, x2::y2::Nil, x3::y3::Nil )
          map( _ map( _ toDouble ) ) )
    }

}
