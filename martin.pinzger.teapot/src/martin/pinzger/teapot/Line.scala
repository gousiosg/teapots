package martin.pinzger.teapot

import scala.math._
import java.awt.geom.Line2D

/**
 * Represents a line in 2D space and implements 
 * basic analytical geometry algorithms.
 * 
 * @author mpinzger, code adapted from Georgios
 *
 */
case class Line(a: Point, b: Point) {
  /** Compute the length of the line */
  def length: Double = sqrt(pow((b.x - a.x), 2) + pow((b.y - a.y), 2))

  def points: List[Point] = List(a, b)

  /** Check whether two lines intersect. */
  def intersects(other: Line): Boolean =
    Line2D.linesIntersect(a.x, a.y, b.x, b.y,
                          other.a.x, other.a.y, other.b.x, other.b.y)

  /**
   * Computes the intersection with another line.
   * 
   * @param line
   * @return Some intersection point otherwise None
   */
  def intersectWith(line: Line): Option[Point] = {
    val line1 = this.linearEquation
    val line2 = line.linearEquation

    if (intersects(line)) {
        var x = 0d
        var y = 0d
	    if (line1._1.isInfinite()) {	// line 1 is a vertical straight line
	      x = this.a.x
	      y = line2._1*x + line2._2
	    } else if (line2._1.isInfinite()) {	// line 2 is a vertical straight line
		  x = line.a.x  
	      y = line1._1*x + line1._2
	    } else {
	      x = (line2._2 - line1._2) / (line1._1 - line2._1)
		  y = line1._1 * x + line1._2
	    } 
		Some(Point(x, y))
    } else {
      None
    }
  }
  
  /**
   * Determines the slope and intercept.
   * Note, a vertical line has slope and intercept Infinity
   *  
   * @return Pair with slope and intercept
   */
  def linearEquation(): (Double, Double) = {
    val k = (b.y-a.y)/(b.x-a.x)
    val d = a.y - k*a.x
    (k, d)
  }
    
  /** Checks whether this line is horizontal/vertical. */
  def isHorizontal = abs(a.y-b.y) < Line.EPSILON
  def isVertical = abs(a.x-b.x) < Line.EPSILON

  /** Checks whether this line contains the provided point. */
  def isOnLine(r: Point) = {
    val line = this.linearEquation
    var error = 0d
    if (line._1.isInfinite()) {	// line is a vertical line
	  error = this.a.x - r.x
	} else if (line._2.isInfinite()) {	// lines is a horizontal line
	  error = this.a.y - r.y
	} else {
      error = r.y - (line._1 * r.x + line._2)
	}
    abs(error) < Point.EPSILON
  }
}

object Line {
  def EPSILON = 0.00000001D

  def apply(points: List[Point]) : Line = {
    assert(points.size == 2)
    Line(points(0), points(1))
  }
}