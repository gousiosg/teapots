object Types {

    type Coord = List[Double]
    def x(c:Coord):Double = c(0)
    def y(c:Coord):Double = c(1)
    def transposeC(c:Coord):Coord = c reverse

    type Triangle = List[Coord]
    def xs(l:Triangle):List[Double] = l map x
    def ys(l:Triangle):List[Double] = l map y
    def transposeT(t:Triangle):Triangle = t map transposeC

    type Triangles = List[Triangle]

}
