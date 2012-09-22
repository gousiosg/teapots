package martin.pinzger.teapot

import java.awt.Dimension
import javax.swing.JComponent
import java.awt.Graphics

/**
 * Canvas for drawing the teapot.
 * 
 * @author mpinzger, code adapted from Georgios.
 *
 */
class MyCanvas(triangles: List[Triangle]) extends JComponent{

  override def getPreferredSize = new Dimension(
    triangles.map(t => t.vertices.map{p => p.x}).flatten.max.toInt + 20,
    triangles.map(t => t.vertices.map{p => p.y}).flatten.max.toInt + 20
  )

  override def getMinimumSize = getPreferredSize

  /* (non-Javadoc)
   * @see javax.swing.JComponent#paintComponent(java.awt.Graphics)
   */
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
        g.drawPolygon(toJava2DPolygon(triangle))
        //g.fillPolygon(triangle.toJava2DPolygon)
    }
  }

  /** Convert triangle to a drawble polygon */
  def toJava2DPolygon(t: Triangle) = new java.awt.Polygon(
    Array(t.vertices(0).x, t.vertices(1).x, t.vertices(2).x).map{x => (x * 1000).toInt / 1000},
    Array(t.vertices(0).y, t.vertices(1).y, t.vertices(2).y).map{x => (x * 1000).toInt / 1000},
    3
  )
}

