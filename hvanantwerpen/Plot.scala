import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Shape;
import java.awt.geom.Path2D;
import javax.swing.JFrame;
import javax.swing.JPanel;
import scala.util.Random
import Types._

object Plot {

    def createShape(t:Triangle) : Shape = {
        val s = new Path2D.Double();
        s.moveTo( x(t(0)), -y(t(0)) );
        s.lineTo( x(t(1)), -y(t(1)) );
        s.lineTo( x(t(2)), -y(t(2)) );
        s.closePath
        s
    }

    def plot(shapes:List[Shape], edges:List[Shape]) = {
        val panel = new JPanel(){

            object RandomColor {
                val r = new Random
                def getNext:Color = new Color(r.nextFloat,r.nextFloat,r.nextFloat)
            }

            override def paintComponent(g:Graphics) = g match {
                case g2:Graphics2D => {
                    val (xt, yt, scale) = prep(shapes, getWidth, getHeight)
                    g2.translate(xt,yt)
                    g2.scale(scale,scale)
                    shapes foreach(shape => {
                        g2.setColor(RandomColor.getNext);
                        g2.fill(shape)
                    })
                    g2.setStroke(new BasicStroke(1.5f/scale.toFloat))
                    g2.setColor(Color.BLACK);
                    edges foreach(edge => {
                        g2.draw(edge)
                    })
                }
                case _ => throw new ClassCastException
            }

            def prep(shapes:List[Shape],w:Double,h:Double) : Tuple3[Double,Double,Double] = {
                val xmin = shapes map(_.getBounds2D.getMinX) reduceLeft(math.min)
                val xmax = shapes map(_.getBounds2D.getMaxX) reduceLeft(math.max)
                val ymin = shapes map(_.getBounds2D.getMinY) reduceLeft(math.min)
                val ymax = shapes map(_.getBounds2D.getMaxY) reduceLeft(math.max)
                val sw = xmax-xmin
                val sh = ymax-ymin
                val scale = math.min(w/sw,h/sh)
                val dw = w - scale*sw
                val dh = h - scale*sh
                ( -scale*xmin+dw/2, -scale*ymin+dh/2, scale )
            }

        }

        val frame = new JFrame()
        frame.getContentPane().add(panel);
        frame.setTitle("Ceci n'est pas une teapot.")
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
        frame.setSize(400,400)
        frame.setVisible(true)
        frame
    }

}
