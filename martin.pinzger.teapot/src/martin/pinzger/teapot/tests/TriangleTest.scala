package martin.pinzger.teapot.tests

import org.junit.Test
import martin.pinzger.teapot.Triangle
import martin.pinzger.teapot.Line
import martin.pinzger.teapot.Point
import scala.testing.SUnit.Assert
import org.junit.Assert
import martin.pinzger.teapot.Main


/**
 * Unit tests to check the core functionality
 * of the algorithm.
 * 
 * @author mpinzger
 *
 */
class TriangleTest {

  @Test def testIsRight() {
    val leftRight = Triangle(List(Point(2, 2), Point(2,4), Point(4, 2)))
    Assert.assertTrue("Left right should be right", leftRight.isRight)
    
    val rightRight = Triangle(List(Point(2,2), Point(4,2), Point(4,4)))
    Assert.assertTrue("Right right should be right", rightRight.isRight)
    
    val topLeftRight = Triangle(List(Point(2,2), Point(2,4), Point(4,4)))
    Assert.assertTrue("To left right should be right", topLeftRight.isRight)
    
    val topRightRight = Triangle(List(Point(2,4), Point(4,4), Point(4,2)))
    Assert.assertTrue("Top right right should be right", topRightRight.isRight)
  }

  @Test def testHasHorizontalOrVerticalLeg() {
    val tr1 = Triangle(List(Point(4,2), Point(2,4), Point(8,9)))
    Assert.assertFalse("No horizontal leg", tr1.hasHorizontalLeg)
    Assert.assertFalse("No vertical leg", tr1.hasVerticalLeg)
    
    val tr2 = Triangle(List(Point(9,2), Point(3,2), Point(14,6)))
    Assert.assertTrue("Has horizontal leg", tr2.hasHorizontalLeg)
    Assert.assertFalse("No vertical leg", tr2.hasVerticalLeg)
    
    val tr3 = Triangle(List(Point(9,2), Point(9,5), Point(14,6)))
    Assert.assertFalse("No horizontal leg", tr3.hasHorizontalLeg)
    Assert.assertTrue("Has vertical leg", tr3.hasVerticalLeg)
  }
  
  @Test def isOnLine() {
    val  line = Line(Point(490.7661464188406,333.0736800168438), Point(490.7661464188406,366.6986452027627))
    Assert.assertFalse("Line shoud not contain point", line.isOnLine(Point(563.5905446018542,333.0736800168438)))
  }
  
  @Test def testSelectMiddleCrossline() {
    val tr1 = Triangle(List(Point(4,2), Point(2,4), Point(8,9)))
    val crossLineTr1 = tr1.selectCrossline
    Assert.assertTrue("Some triangle", crossLineTr1.isOnLine(Point(2,4)) && crossLineTr1.isOnLine(Point(7,4))) 

    val tr2 = Triangle(List(Point(9,2), Point(3,2), Point(14,6)))
    val crossLineTr2 = tr2.selectCrossline
    Assert.assertTrue("Triangle with a horizontal leg", crossLineTr2.isOnLine(Point(9,2)) && crossLineTr2.isOnLine(Point(9,15)))
  }
    
  @Test def testSplitting() {
    val tr1 = Triangle(List(Point(361,169), Point(308,164), Point(308,168)))
    val crossLineTr1 = tr1.selectCrossline
    Assert.assertTrue("Triangle with horizontal cross line on 168", crossLineTr1.isOnLine(Point(10,168)))
    val trianglesTr1 = tr1.splitTriangle()
    Assert.assertEquals("Split should result in 2 new triangles", 2, trianglesTr1.size)
    Assert.assertTrue("Parent should contain split triangle", tr1.contains(trianglesTr1(0)))
    Assert.assertTrue("Parent should contain split triangle", tr1.contains(trianglesTr1(1)))
    
    val tr2 = Triangle(List(Point(483.81,333.07), Point(583.93,323.68), Point(585.89,282.79)))
    val crossLineTr2 = tr2.selectCrossline
    Assert.assertTrue("Triangle with horizontal cross line on 323.68", crossLineTr2.isOnLine(Point(10,323.68)))
    val trianglesTr2 = tr2.splitTriangle()
    Assert.assertEquals("Split should result in 2 new triangles", 2, trianglesTr2.size)
    Assert.assertTrue("Parent should contain split triangle", tr2.contains(trianglesTr2(0)))
    Assert.assertTrue("Parent should contain split triangle", tr2.contains(trianglesTr2(1)))
  }
  
  @Test def testIntersection() {
      val line1 = Line(Point(0,0), Point(3,1))
      val line2 = Line(Point(0,1), Point(2.5,0))
      
      val intersectionPoint = line1.intersectWith(line2).get
      
      Assert.assertEquals(intersectionPoint.x, 1.36, 0.01)
      Assert.assertEquals(intersectionPoint.y, 0.45, 0.01)
  }
}