package martin.pinzger.teapot

import scala.math._

/**
 * Triangle specified by a list of three vertices.
 * 
 * @author mpinzger, class adapted from Georgios
 * 
 */
case class Triangle(vertices: List[Point]) {
  /** Triangle must consist of exactly three points */
  assert(vertices.size == 3)
  /** Vertices must be unique */
  assert(vertices.groupBy(x => x.hashCode).size == 3)

  /** Determine whether the triangle has a vertical or horizontal edge */
  def hasHorizontalLeg = vertices.map(p => round(p.y * (1/Line.EPSILON)) / (1/Line.EPSILON)).distinct.size != 3
  def hasVerticalLeg = vertices.map(p => round(p.x * (1/Line.EPSILON)) / (1/Line.EPSILON)).distinct.size != 3

  /** Determine if the triangle is a right triangle*/
  def isRight = hasHorizontalLeg && hasVerticalLeg

  /** Convert triangle vertices to a list of edges */
  def asLines = List(
    Line(vertices(0), vertices(1)),
    Line(vertices(1), vertices(2)),
    Line(vertices(0) , vertices(2)))

  /** Calculate the triangle's area */
  def area = abs(((vertices(0).x - vertices(2).x) * (vertices(1).y - vertices(0).y) -
    (vertices(0).x - vertices(1).x) * (vertices(2).y - vertices(0).y)) * 0.5)

  /** Min and max x and y of the three vertices */
  def maxX = vertices.map{p => p.x}.max
  def maxY = vertices.map{p => p.y}.max
  def minX = vertices.map{p => p.x}.min
  def minY = vertices.map{p => p.y}.min

  /** Create 3 lines that pass through each one of the triangle's vertices and are vertical or horizonal */
  def verticalCrossLines = vertices.map{p => Line(Point(p.x, minY), Point(p.x, maxY))}
  def horizontalCrossLines = vertices.map{p => Line(Point(minX, p.y), Point(maxX, p.y))}

  /**
   * Determine the crossline for splitting the triangle
   * by sorting the vertices and determine the middle one.
   * Use the horizontal line except the triangle already 
   * has a horizontal leg.
   * 
   * @return The crossline
   */
  def selectCrossline(): Line = {
    if (hasHorizontalLeg) {
    	verticalCrossLines.sortWith((e1: Line, e2: Line) => e1.a.x > e2.a.x)(1)
    } else {
    	horizontalCrossLines.sortWith((e1: Line, e2: Line) => e1.a.y > e2.a.y)(1)
    }
  }
  
  /**
   * Determines the crossline and uses it to split
   * the triangle into two sub-triangles. Default is
   * to split via the horizontal crossline.
   * 
   * @return The two triangles resulting from the split.
   */
  def splitTriangle(): List[Triangle] = {
    val crossline = selectCrossline
    assert(crossline.isHorizontal || crossline.isVertical)

    val splitVertex = vertices.filter{v => crossline.isOnLine(v)}
    val otherVertices = vertices.filter{v => !crossline.isOnLine(v)}
    assert(splitVertex.size == 1)
    assert(otherVertices.size == 2)
    assert(otherVertices(0) != otherVertices(1))
    
    val intersectionPoint = (new Line(otherVertices(0), otherVertices(1))).intersectWith(crossline).get
    assert(Line(otherVertices(0), otherVertices(1)).isOnLine(intersectionPoint))

    val firstTriangle = Triangle(List(splitVertex(0), intersectionPoint, otherVertices(0)))
    val secondTriangle = Triangle(List(splitVertex(0), intersectionPoint, otherVertices(1)))

    // check the triangle all must ly within the original triangle
    assert(this.contains(firstTriangle))
    assert(this.contains(secondTriangle))
    
    List(firstTriangle, secondTriangle)
  }

  /**
   * Checks whether the given triangle is obtained from this
   * triangle (points of the triangle must ly on the lines
   * of this triangle).
   * 
   * @param subTriangle
   * @return true if it is, false otherwise.
   */
  def contains(subTriangle: Triangle): Boolean = {
    subTriangle.vertices.filter(p => 
    	Line(this.vertices(0), this.vertices(1)).isOnLine(p) ||
    	Line(this.vertices(1), this.vertices(2)).isOnLine(p) ||
    	Line(this.vertices(2), this.vertices(0)).isOnLine(p)
    ).size == 3
  }  
}