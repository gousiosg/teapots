import io.Source
import java.awt.{Graphics, Dimension}
import java.awt.geom.Line2D
import javax.swing.{JComponent, JFrame}
import scala.math._

case class Point(x: Double, y: Double) {
  /** Approximate comparison of two points. If the provided point is within a range of (-EPSILON, +EPSILON)
    * of this then the two are considered close enough to be indistinguishable. */
  def isClose(p: Point) = abs(this.x - p.x) < Point.EPSILON && abs(this.y - p.y) < Point.EPSILON

  /** Redefine equality using approximate comparisons */
  def ==(p: Point) = isClose(p)

  def equals(p: Point) = isClose(p)

  def !=(p: Point) = !isClose(p)
}

object Point {

  val EPSILON = 0.0001

  def apply(coords: Array[Double]): Point = {
    assert(coords.size == 2)
    Point(coords(0), coords(1))
  }
}

/** Represents a line in 2D space and implements basic analytical geometry algorithms */
case class Line(a: Point, b: Point) {
  /** Length of the line */
  def length: Double = sqrt(pow((b.x - a.x), 2) + pow((b.y - a.y), 2))

  def points: List[Point] = List(a, b)

  /** Check whether two lines intersect. */
  def intersects(other: Line): Boolean =
    Line2D.linesIntersect(a.x, a.y, b.x, b.y,
                          other.a.x, other.a.y, other.b.x, other.b.y)

  /** Intersection point between two lines, if one exists. */
  def intersectionPoint(l: Line): Option[Point] = {

    val d = (b.x - a.x) * (l.b.y - l.a.y) - (b.y - a.y) * (l.b.x - l.a.x)
    if (d == 0) return None

    val xi = ((l.a.x - l.b.x) * (a.x * b.y - a.y * b.x) - (a.x - b.x) * (l.a.x * l.b.y - l.a.y * l.b.x)) / d
    val yi = ((l.a.y - l.b.y) * (a.x * b.y - a.y * b.x) - (a.y - b.y) * (l.a.x * l.b.y - l.a.y * l.b.x)) / d

    Some(Point(xi, yi))
  }

  def isHorizontal = abs(a.y - b.y) < Point.EPSILON

  def isVertical = abs(a.x - b.x) < Point.EPSILON

  /** Checks whether a line goes through all provided points. */
  def goesThrough(points: List[Point]): List[Point] = points.filter(p => isOnLine(p))

  /** Checks whether this line contains the provided point. */
  def isOnLine(r: Point) =
    min(a.x, b.x) <= r.x && max(a.x, b.x) >= r.x &&
    min(a.y, b.y) <= r.y && max(a.y, b.y) >= r.y &&
    abs((a.x - b.x) * (r.y - a.y) - (b.y - a.y) * (r.x - a.x)) < Point.EPSILON
}

object Line {
  def apply(points: List[Point]) : Line = {
    assert(points.size == 2)
    Line(points(0), points(1))
  }
}

/** A 2D triangle representation */
case class Triangle(vertices: List[Point]) {

  //System.err.println("Triangle:" + vertices + "area: " + area)

  //A triangle only consists of 3 points
  assert(vertices.size == 3)

  //Points are unique
  assert(vertices.groupBy(x => x.hashCode).size == 3)

  /** Determine whether the triangle has a vertical or horizontal edge. The comparison
    * is aproximate to the 4 decimal digit. If */
  def hasHorizontalLeg: Boolean = vertices.map(p => (p.y * 1000).toInt / 1000).distinct.size != 3
  def hasVerticalLeg: Boolean = vertices.map(p => (p.x * 1000).toInt / 1000).distinct.size != 3

  private def getLeg(selector: Point => Double) : Line =
    vertices groupBy(selector) collectFirst{case x if x._2.size == 2 => x._2} match {
      case Some(x) => Line(x)
      case None => throw new Exception("Triangle does not contain legs")
  }

  /** Return the triangle's horizontal edge (if exists) */
  def horizontalLeg = getLeg(p => p.y)

  /** Return the triangle's vertical edge (if exists) */
  def verticalLeg = getLeg(p => p.x)

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

  def maxX = vertices.map{p => p.x}.max
  def maxY = vertices.map{p => p.y}.max

  def minX = vertices.map{p => p.x}.min
  def minY = vertices.map{p => p.y}.min

  /** Create 3 lines that pass through each one of the triangle's vertices and are vertical or horizonal */
  def verticalCrossLines = vertices.map{p => Line(Point(p.x, minY), Point(p.x, maxY))}
  def horizontalCrossLines = vertices.map{p => Line(Point(minX, p.y), Point(maxX, p.y))}

  /** Get the edges that have at least one common point to the provided line */
  def intersectingEdges(b: Line): List[Line] = asLines.filter(l => l.intersects(b))

  /** Use the provided crossline to split the triangle in two*/
  def splitTriangle(crossline: Line): List[Triangle] = {
    assert(crossline.isHorizontal || crossline.isVertical)

    val splitVertex = if(vertices.contains(crossline.a)) crossline.a else crossline.b
    val otherVertices = vertices.filter{v => !crossline.isOnLine(v)}
    val intersectionPoint = (new Line(otherVertices(0), otherVertices(1))).intersectionPoint(crossline).get

    assert(otherVertices.size == 2)
    assert(otherVertices(0) != otherVertices(1))

    List(
      Triangle(List(splitVertex, intersectionPoint, otherVertices(0))),
      Triangle(List(splitVertex, intersectionPoint, otherVertices(1)))
    )
  }

  /** Convert triangle to a drawble polygon */
  def toJava2DPolygon = new java.awt.Polygon(
    Array(vertices(0).x, vertices(1).x, vertices(2).x).map{x => (x * 1000).toInt / 1000},
    Array(vertices(0).y, vertices(1).y, vertices(2).y).map{x => (x * 1000).toInt / 1000},
    3
  )
}

class MyCanvas(triangles: List[Triangle])
  extends JComponent{

  override def getPreferredSize = new Dimension(
    triangles.map(t => t.vertices.map{p => p.x}).flatten.max.toInt + 20,
    triangles.map(t => t.vertices.map{p => p.y}).flatten.max.toInt + 20
  )

  override def getMinimumSize = getPreferredSize

  override def paintComponent(g: Graphics) = {
    super.paintComponent(g)

    val colours = Map(
      0 -> java.awt.Color.black,
      1 -> java.awt.Color.blue,
      2 -> java.awt.Color.green,
      3 -> java.awt.Color.red,
      4 -> java.awt.Color.white
    )

    val rng = new scala.util.Random()

    triangles.foreach {
      triangle =>
        g.setColor(colours.get(rng.nextInt(5)).get)
        g.drawPolygon(triangle.toJava2DPolygon)
        //g.fillPolygon(triangle.toJava2DPolygon)
    }
  }
}

object Main {

  def bench(func: Unit => List[Triangle]) : List[Triangle] = {
    val start = System.currentTimeMillis
    val result = func.apply()
    val total = System.currentTimeMillis - start
    System.err.println(result.size + " triangles in " + total + "msec")
    result
  }

  def split(t: Triangle): List[Triangle] = {
    if (t.isRight || t.area < 10)
      return List(t)

    val result = if (t.hasHorizontalLeg) {
      t.splitTriangle(t.verticalCrossLines.filter(v => t.intersectingEdges(v).size == 3)(0))
    } else {
      t.splitTriangle(t.horizontalCrossLines.filter(v => t.intersectingEdges(v).size == 3)(0))
    }

    t :: result.flatMap(x => split(x))
  }

  def main(args: Array[String]) {
    gui(bench(x => load.flatMap(x => split(x)).toList))
    //gui(load)
    //test
  }

  def load: List[Triangle] =
    Source.fromFile("pot.txt").getLines.toList.foldLeft(List[Triangle]()) {
      (acc, line) => line match {
        case l if l.trim.size == 0 => acc
        case _ => Triangle(
            line.replace("{", "").replace("}", "").split("\",").map {
              x => Point(x.replace("\"", "").split(",").map {
                y =>
                  y.toDouble
              })
            }.map(p => Point((p.x * 800) + 600, (p.y * -800) + 1050)).toList

          ) :: acc
      }
    }

  def gui(input: List[Triangle]) = {
    val frame = new JFrame("Triangle decomposition");
    frame.getContentPane().add(new MyCanvas(input))
    frame.pack
    frame.setVisible(true);
  }

  def test = {
    val tr1 = Triangle(List(Point(4,2), Point(2,4), Point(8,9)))
    val tr2 = Triangle(List(Point(9,2), Point(3,2), Point(14,6)))
    val tr3 = Triangle(List(Point(9,2), Point(9,5), Point(14,6)))
    val right = Triangle(List(Point(2, 2), Point(2,4), Point(4, 2)))

    assert(tr2.hasHorizontalLeg)
    assert(!tr1.hasHorizontalLeg)
    assert(tr3.hasVerticalLeg)
    assert(!tr3.hasHorizontalLeg)

    //Leg tests
    assert(tr2.horizontalLeg == Line(Point(9,2), Point(3,2)))
    assert(tr3.verticalLeg == Line(Point(9,2), Point(9,5)))

    assert(right.isRight)
    assert(right.hasHorizontalLeg && right.hasVerticalLeg)

    //Line tests
    val line = Line(Point(1,1), Point(5,1))
    assert(line.isOnLine(Point(3,1)))
    assert(line.isOnLine(Point(5,1)))
    assert(!line.isOnLine(Point(4,3)))
    assert(!line.isOnLine(Point(6,1)))

    assert(line.goesThrough(List(Point(3,1), Point(4,1))).size == 2)

    assert(line.intersectionPoint(Line(Point(2.5, 0), Point(2.5, 2))).get == Point(2.5, 1))
    assert(Line(Point(2.5, 0), Point(2.5, 2)).intersectionPoint(line).get == Point(2.5, 1))
    assert(line.intersectionPoint(Line(Point(6.5, 0), Point(2.5, 2))) != None)

    //Intersection tests
    val tr4 = Triangle(List(Point(0,200), Point(300, 0), Point(600, 200)))
    val lines = tr4.verticalCrossLines

    val intersectingEdge = lines.filter(v => tr4.intersectingEdges(v).size == 3)(0)
    assert(lines.size == 3)
    assert(intersectingEdge == Line(Point(300.0,0.0), Point(300.0, 200.0)))


    //
    val tr5 = Triangle(List(Point(361.7787381822439,169.22713952883583),
      Point(308.26798025213,164.20843040895534), Point(308.87805906566416,168.2415433935683)))

    //gui(List(tr5))
    //tr5.split

    val tr6 = Triangle(List(Point(308.26798025213,164.20843040895534), Point(362.5780531718777,164.2084304089553), Point(361.7787381822439,169.22713952883583)))
    //gui(List(tr6))
    //split(tr6)


    val tr7 = Triangle(List(Point(417.056491724005,337.5757610405967), Point(527.5437195222013,337.5757610405966), Point(536.3259866231654,398.7041478115675)))
    //gui(List(tr7))
    //gui(split(tr7))
  }
}