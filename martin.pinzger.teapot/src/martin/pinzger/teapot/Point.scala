package martin.pinzger.teapot

import scala.math._

/**
 * Point in a 2D space.
 * 
 * @author mpinzger, code adapted from Georgios.
 *
 */
case class Point(x: Double, y: Double) {
  /** Approximate comparison of two points. If the provided point is within a range of (-EPSILON, +EPSILON)
    * of this then the two are considered close enough to be indistinguishable. */
  def isClose(p: Point) = abs(this.x - p.x) < Point.EPSILON && abs(this.y - p.y) < Point.EPSILON

  /** Redefine equality using approximate comparisons */
  def ==(p: Point) = isClose(p)
  def equals(p: Point) = isClose(p)
  def !=(p: Point) = !isClose(p)
}

/**
 * Point object with factory method.
 * 
 * @author mpinzger
 */
object Point {
  /** Epsilon for comparing points */
  def EPSILON = 0.0000000001

  def apply(coords: Array[Double]): Point = {
    assert(coords.size == 2)
    Point(coords(0), coords(1))
  }
}
