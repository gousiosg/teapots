using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Globalization;
using System.IO;

namespace TeaPot
{
    class Program
    {
        static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            var panel = new Panel { Dock = DockStyle.Fill, BackColor = Color.AliceBlue };

            var xs = File.ReadAllLines(@"C:\Users\emeijer\Dropbox\LINQPad Queries\TweakedPot.txt");

            var triangles = xs.Select(line => line.Split(new[] { @"}"",""{" }, StringSplitOptions.RemoveEmptyEntries)
                                                  .Select(p =>
                                                  {
                                                      var ps = p.Trim('"', '{', '}', '"').Split(',');
                                                      return new PointF
                                                      { X = float.Parse(ps[0], CultureInfo.InvariantCulture)
                                                      , Y = float.Parse(ps[1], CultureInfo.InvariantCulture)
                                                      };
                                                  }));

            var normalized = triangles.Where(t => t.Count() == 3)
                                      .Select(t => t.Select(p => 
                                          new PointF((p.X * 800) + 600, (p.Y * -800) + 1050))
                                      .OrderBy(i => i.X).OrderBy(i => i.Y).ToArray());
            panel.Paint += (s, e) =>
            {
                var nrTriangles = 0;
                var graphics = panel.CreateGraphics();

                var divs = new List<string>();
                divs.Add(@"<div style=""position:relative;background-color:#b0c4de; width: 1200px; height: 600px;"">");

                foreach (var triangle in normalized)
                {
                    // uncomment to show original triangles
                    //graphics.DrawPolygon(new Pen(Color.Black, 2), triangle);

                    var rc = Triangle.RandomColor();

                    var split = new[] { triangle }
                              .Expand(Triangle.Split)
                              .Where(Triangle.IsRight);

                    nrTriangles += split.Count();
                    foreach (var right in split)
                    {
                        graphics.FillPolygon(new SolidBrush(rc), right);
                        //graphics.DrawPolygon(new Pen(Color.Red, 1), right);

                        // uncomment to paint slowly
                        //System.Threading.Thread.Sleep(100);     
                        divs.Add(Div.FromTriangle(rc, right).ToString());
                        
                    }
                }

                divs.Add("</div>");
                File.WriteAllLines(@"..\..\teapot.html", divs);
                Console.WriteLine("nrTriangles = {0}", nrTriangles);

            };

            Application.Run(new Form()
            { ClientSize = new System.Drawing.Size(1200, 600)
            , Controls = { panel }
            , Text = "TeaPot"
            });
        }
    }
}
