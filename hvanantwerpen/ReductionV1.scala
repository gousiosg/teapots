import Types._

object ReductionV1 {

    def reduceTriangles(threshold:Double, ts:Triangles) = {
        ts flatMap( reduceTriangle(threshold)(_) )
    }

    def reduceTriangle(threshold:Double)(t:Triangle) : Triangles = {
        def step1(t:Triangle):Triangles =
                bigenough( threshold, t ) fold( List(_), step2 )
        def step2(t:Triangle):Triangles =
                split( t ) fold( ts => ts, ts => ts ) flatMap( step3 )
        def step3(t:Triangle):Triangles =
                split( transposeT(t) ) fold( _ map( transposeT ), _ map( transposeT ) flatMap( step1 ) )
        step1(t)
    }

    def bigenough(threshold:Double,t:Triangle) : Either[Triangle,Triangle] = {
        def sqsum(is:List[Double]):Double =
                is map( i => i*i ) reduceLeft( (i,j) => i+j )
        if ( sqsum( xs(t) ) <= threshold || sqsum( ys(t) ) <= threshold ) {
            Left(t)
        } else {
            Right(t)
        }
    }

    def split(t:Triangle) : Either[Triangles,Triangles] = {
        val cs = t sortWith( (c0,c1) => y(c0) < y(c1) || ( y(c0) == y(c1) && x(c0) < x(c1)) )
        val rightEdge = y(cs(0)) == y(cs(1)) || y(cs(1)) == y(cs(2))
        if ( rightEdge ) {
            Left( cs::Nil )
        } else {
            val w = x(cs(0)) - x(cs(2))
            val l = y(cs(2)) - y(cs(0))
            val b = y(cs(2)) - y(cs(1))
            val c4 = List( x(cs(2)) + w*(b/l), y(cs(1)) )
            Right( List( cs(0)::cs(1)::c4::Nil, cs(1)::cs(2)::c4::Nil ) )
        }
    }

}
