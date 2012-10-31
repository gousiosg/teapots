using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace teapot2
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            
            
            InitializeComponent();

            Main();
        }

        static Random randonGen = new Random();

        IEnumerable<PointF[]> readTriangles()
        {
            using (var sr = new StreamReader(@"teapot.txt"))
            {
                while (sr.Peek() > 0)
                {
                    string line = sr.ReadLine();

                    float[] ps = line.Replace("\"", "").Replace("{", "").Replace("}", "").Split(',').Select(j => float.Parse(j.Trim(),CultureInfo.InvariantCulture)).ToArray();
                    yield return new PointF[]{
						new PointF( (ps[0]+.8f) * 600f, (-ps[1]+1.5f) * 600f)
						, new PointF( (ps[2]+.8f) * 600f, (-ps[3]+1.5f) * 600f)
						, new PointF( (ps[4]+.8f) * 600f, (-ps[5]+1.5f) * 600f)
					};
                }
            }
        }

        double Distance(PointF a, PointF b)
        {
            return Math.Sqrt(Math.Pow((a.X - b.X), 2) + Math.Pow((a.Y - b.Y), 2));
        }

        bool TooSmall(PointF[] points)
        {
            if (Distance(points[0], points[1]) < 1e-2) return true;
            if (Distance(points[0], points[2]) < 1e-2) return true;
            if (Distance(points[2], points[1]) < 1e-2) return true;

            return false;
        }


        /// <summary>
        /// Split the triangle in East - West orientation
        /// </summary>
        /// <param name="points"></param>
        /// <returns></returns>
        IEnumerable<PointF[]> splitHorizontal(PointF[] points)
        {
            var ps = points.OrderBy(p => p.X).ThenBy(p => p.Y).ToArray();

            Func<float, float> calcY = (x) => (ps[0].Y - ps[2].Y) / (ps[0].X - ps[2].X) * (x - ps[2].X) + ps[2].Y;

            PointF p4 = new PointF(ps[1].X, calcY(ps[1].X));

            yield return new PointF[] { ps[0], ps[1], p4 };
            yield return new PointF[] { ps[2], ps[1], p4 };
        }

        /// <summary>
        /// Split the triangle in two parts, North and South
        /// </summary>
        /// <param name="ps"></param>
        /// <returns></returns>
        IEnumerable<PointF[]> splitVertical(PointF[] points)
        {
            var ps = points.OrderBy(p => p.Y).ThenBy(p => p.X).ToArray();

            Func<float, float> calcX = (y) => (ps[2].X - ps[0].X) / (ps[2].Y - ps[0].Y) * (y - ps[0].Y) + ps[0].X;


            PointF p4 = new PointF(calcX(ps[1].Y), ps[1].Y);

            yield return new PointF[] { ps[0], ps[1], p4 };
            yield return new PointF[] { ps[2], ps[1], p4 };
        }

        /// <summary>
        /// Check if triangle has an horizontal line
        /// </summary>
        /// <param name="ps"></param>
        /// <returns></returns>
        bool hasHorizontal(PointF[] ps)
        {
            return ps[0].Y == ps[1].Y
                || ps[1].Y == ps[2].Y
                || ps[0].Y == ps[2].Y;
        }

        /// <summary>
        /// Check if triangle has a vertical line
        /// </summary>
        /// <param name="ps"></param>
        /// <returns></returns>
        bool hasVertical(PointF[] ps)
        {
            return ps[0].X == ps[1].X
                || ps[1].X == ps[2].X
                || ps[0].X == ps[2].X;
        }



        IEnumerable<PointF[]> newTriangles(PointF[] triangle, int stack = 0)
        {
            // Dont use too many triangles!
            if (!TooSmall(triangle))
            {
                Func<PointF[], IEnumerable<PointF[]>> splitter = null;
                bool hasHorizontalLine = hasHorizontal(triangle);
                bool hasVerticalLine = hasVertical(triangle);

                // We have found a Rectangular Triangle
                if (hasHorizontalLine && hasVerticalLine)
                {
                    yield return triangle;
                }
                else
                {
                    // If there is no horizontal line in the triangle we can create one by splitting it vertically
                    if (!hasHorizontalLine)
                    {
                        splitter = splitVertical;
                    }
                    // If there is no vertical line in the triangle we can create one by splitting it horizontally
                    else if (!hasVerticalLine)
                    {
                        splitter = splitHorizontal;
                    }

                    // Do the actual splitting and recursive call on the new triangles, unfold the results and yield them one by one
                    foreach (var nt in splitter(triangle))
                        foreach (var rt in newTriangles(nt, ++stack))
                            yield return rt;
                }
            }
        }

        void Main()
        {
            var triangles = readTriangles();/*new[]{ new[]{new PointF(0,200),new PointF(300,0),new PointF(600,200)}
				, new[]{ new PointF(0,200),new PointF(600,200),new PointF(300,400)}
				 , new[]{ new PointF(0,200),new PointF(300,400),new PointF(0,500)}
				 , new[]{ new PointF(300,400),new PointF(0,500),new PointF(300,700)}
				 , new[]{ new PointF(600,200),new PointF(300,400),new PointF(300,700)}
				 , new[]{ new PointF(600,200),new PointF(300,700),new PointF(600,500)} 
			};*/

            var panel = panel1;// new Panel { }.Dump("Cube");

            panel.Paint += (s, e) =>
            {
                var graphics = panel.CreateGraphics();
                var input = triangles;

                foreach (var t in input)
                {
                    graphics.FillPolygon(new SolidBrush(RandomColor()), t);
                }

                Pen p = new Pen(Color.Black, 2);

                foreach (var tri in input)
                {
                    foreach (var rt in newTriangles(tri))
                        graphics.FillPolygon(new SolidBrush(RandomColor()), rt); // graphics.DrawPolygon(p, rt);

                }

            };

        }
        static Color RandomColor()
        {
            return Color.FromArgb(randonGen.Next(255), randonGen.Next(255), randonGen.Next(255));
        }
    }
}
