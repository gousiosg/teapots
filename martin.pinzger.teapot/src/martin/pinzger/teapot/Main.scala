package martin.pinzger.teapot

import io.Source
import javax.swing.{JComponent, JFrame}

/**
 * Main class to compute and draw the teapot.
 * 
 * @author mpinzger, code adapted from Georgios.
 */
object Main {
  val fileName = "input/pot.txt"
  
  /**
   * Outputting some info for the benchmark. 
   * 
   * @param func
   * @return
   */
  def bench(func: Unit => List[Triangle]) : List[Triangle] = {
    val start = System.currentTimeMillis
    val result = func.apply()
    val total = System.currentTimeMillis - start
    System.err.println(result.size + " triangles in " + total + "msec")
    result
  }

  /**
   * Recursively split the given triangle.
   * 
   * @param t	the triangle.
   * @return	the list of contained triangles.
   */
  def split(t: Triangle): List[Triangle] = {
    if (t.isRight || t.area < 1)
      return List(t)

    val result = t.splitTriangle()
    t :: result.flatMap(x => split(x))
  }

  /**
   * Main method.
   * 
   * @param args
   */
  def main(args: Array[String]) {
    gui(bench(x => load.flatMap(x => split(x)).toList))
    gui(load)
  }

  /**
   * Read the list of triangles from the file.
   * 
   * @return List of triangles.
   */
  def load: List[Triangle] =
    Source.fromFile(fileName).getLines.toList.foldLeft(List[Triangle]()) {
      (acc, line) => line match {
        case l if l.trim.size == 0 => acc
        case _ => Triangle(
            line.replace("{", "").replace("}", "").split("\",").map {
              x => Point(x.replace("\"", "").split(",").map {
                y => y.toDouble
              })
            }.map(p => Point((p.x * 800) + 600, (p.y * -800) + 1050)).toList

          ) :: acc
      }
    }

  /**
   * Represent the teapot.
   * 
   * @param input	the list of triangles to paint.
   */
  def gui(input: List[Triangle]) = {
    val frame = new JFrame("Triangle decomposition");
    frame.getContentPane().add(new MyCanvas(input))
    frame.pack
    frame.setVisible(true);
  }
}