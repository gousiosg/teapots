using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace TeaPot
{
    public static class Triangle
    {
        /// <summary>
        /// c is to the left of the line determined by a and b
        /// </summary>
        public static bool IsLeft(this PointF c, PointF a, PointF b)
        {
           return (c.Y-a.Y)*(b.X-a.X) - (c.X-a.X)*(b.Y-a.Y) > 0; 
        }

        /// <summary>
        /// Area of triangle is below treshold (probably not the best way to determine if a triangle is small)
        /// </summary>
        public static bool IsSmall(this PointF[] triangle)
        {
            return triangle.Area() < 30.0;
        }

        /// <summary>
        ///  /\
        /// /  \
        /// ----
        /// </summary>
        public static bool IsAcuteUp(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) 
                && (triangle[0].Y <= triangle[1].Y)
                && (triangle[1].X < triangle[0].X)
                && (triangle[0].X < triangle[2].X);
        }

        /// <summary>
        /// -----
        /// \   /
        ///  \ /
        /// </summary>
        public static bool IsAcuteDown(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) 
                && triangle[2].Y >= triangle[0].Y
                && triangle[0].X < triangle[2].X 
                && triangle[2].X < triangle[1].X;
        }

        /// <summary>
        /// TopLeft || TopRight || BottomLeft || BottomRight
        /// </summary>
        public static bool IsRight(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) &&
            (   triangle[0].X == triangle[1].X
            ||  triangle[0].X == triangle[2].X
            ||  triangle[1].X == triangle[2].X
            );
        }

        public static bool IsBottomRight(this PointF[] triangle)
        {
            return triangle.IsRight() && triangle[0].X == triangle[2].X && triangle[0].Y < triangle[2].Y
                                      && triangle[1].Y == triangle[2].Y && triangle[1].X < triangle[2].X;
        }

        public static bool IsTopRight(this PointF[] triangle)
        {
            return triangle.IsRight() && triangle[0].Y == triangle[1].Y && triangle[0].X < triangle[1].X
                                      && triangle[1].X == triangle[2].X && triangle[1].Y < triangle[2].Y;
        }

        public static bool IsBottomLeft(this PointF[] triangle)
        {
            return triangle.IsRight() && triangle[0].X == triangle[1].X && triangle[0].Y < triangle[1].Y
                                      && triangle[1].Y == triangle[2].Y && triangle[1].X < triangle[2].X;
        }

        public static bool IsTopLeft(this PointF[] triangle)
        {
            return triangle.IsRight() && triangle[0].Y == triangle[1].Y && triangle[0].X < triangle[1].X
                                      && triangle[0].X == triangle[2].X && triangle[0].Y < triangle[2].Y;
        }

        public static bool IsObtuseUpLeft(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) 
                    && triangle[0].Y < triangle[1].Y
                    && triangle[0].X < triangle[1].X;
        }

        /// <summary>
        ///    /|
        ///   / /
        ///  /  |
        /// /  /
        /// ---
        /// </summary>
        public static bool IsObtuseUpRight(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) 
                    && triangle[0].Y < triangle[1].Y
                    && triangle[0].X > triangle[2].X;
        }

        public static bool IsObtuseDownLeft(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) 
                && triangle[2].Y > triangle[0].Y
                && triangle[2].X < triangle[0].X;
        }

        public static bool IsObtuseDownRight(this PointF[] triangle)
        {
            return HasHorizontalLeg(triangle) 
                && triangle[2].Y > triangle[0].Y
                && triangle[2].X > triangle[1].X;
        }

        public static bool IsTiltedRight(this PointF[] triangle)
        {
            return !HasHorizontalLeg(triangle) 
                && !triangle[1].IsLeft(triangle[0], triangle[2]);
        }

        /// <summary>
        ///   /|
        ///  / |
        ///  \ |
        ///   \|
        /// </summary>
        public static bool IsTiltedLeft(this PointF[] triangle)
        {
            return !HasHorizontalLeg(triangle) 
                &&  triangle[1].IsLeft(triangle[0], triangle[2]);
        }

        /// <summary>
        /// /-----\
        /// </summary>
        public static bool HasHorizontalLeg(this PointF[] triangle)
        {
            return triangle[0].Y == triangle[1].Y
                || triangle[1].Y == triangle[2].Y;
        }

        public static float Area(this PointF[] triangle)
        {
            return Math.Abs((triangle[0].X 
                            * (triangle[1].Y - triangle[2].Y) + triangle[1].X 
                            * (triangle[2].Y - triangle[0].Y) + triangle[2].X 
                            * (triangle[0].Y - triangle[1].Y)) 
                            / 2);
        }

        /// <summary>
        /// Split once.
        /// </summary>
        public static IEnumerable<PointF[]> Split(this PointF[] triangle)
        {
            if (IsRight(triangle))
            {
                yield break;
            }

            if (IsAcuteUp(triangle))
            {
                var p = new PointF(triangle[0].X, triangle[1].Y);

                yield return new[] { triangle[0], triangle[1], p };
                yield return new[] { triangle[0], p, triangle[2] };
                yield break;
            }

            if (IsAcuteDown(triangle))
            {
                var p = new PointF(triangle[2].X, triangle[0].Y);

                yield return new[] { triangle[0], p, triangle[2] };
                yield return new[] { p, triangle[1], triangle[2] };
                yield break;
            }

            if (IsObtuseUpLeft(triangle))
            {
                var A = triangle[2].Y - triangle[0].Y;
                var B = triangle[2].X - triangle[1].X;
                var C = triangle[2].X - triangle[0].X;
                var D = A * (B / C);

                var p = new PointF(triangle[1].X, triangle[1].Y - D);

                yield return new[] { triangle[0], p, triangle[1] };
                yield return new[] { p, triangle[1], triangle[2] };
                yield break;
            }

            if (IsObtuseUpRight(triangle))
            {
                var A = triangle[1].Y - triangle[0].Y;
                var B = triangle[0].X - triangle[2].X;
                var C = triangle[0].X - triangle[1].X;
                var D = A * (B / C);

                var p = new PointF(triangle[2].X, triangle[0].Y + D);

                yield return new[] { triangle[0], p, triangle[2] };
                yield return new[] { p, triangle[1], triangle[2] };
                yield break;
            }

            if (IsObtuseDownLeft(triangle))
            {
                var A = triangle[2].Y - triangle[0].Y;
                var B = triangle[1].X - triangle[0].X;
                var C = triangle[1].X - triangle[2].X;
                var D = A * (B / C);

                var p = new PointF(triangle[0].X, triangle[0].Y + D);

                yield return new[] { triangle[0], triangle[1], p };
                yield return new[] { triangle[0], p, triangle[2] };
                yield break;
            }

            if (IsObtuseDownRight(triangle))
            {
                var A = triangle[2].Y - triangle[1].Y;
                var B = triangle[1].X - triangle[0].X;
                var C = triangle[2].X - triangle[0].X;
                var D = A * (B / C);

                var p = new PointF(triangle[1].X, triangle[1].Y + D);

                yield return new[] { triangle[0], triangle[1], p };
                yield return new[] { triangle[1], p, triangle[2] };
                yield break;
            }

            if (IsTiltedRight(triangle))
            {
                var A = triangle[0].X - triangle[2].X;
                var B = triangle[2].Y - triangle[1].Y;
                var C = triangle[2].Y - triangle[0].Y;
                var D = A * (B / C);

                var p = new PointF(triangle[2].X + D, triangle[1].Y);

                yield return new[] { triangle[0], p, triangle[1] };
                yield return new[] { p, triangle[1], triangle[2] };
                yield break;
            }

            if (IsTiltedLeft(triangle))
            {
                var A = triangle[0].X - triangle[2].X;
                var B = triangle[1].Y - triangle[0].Y;
                var C = triangle[2].Y - triangle[0].Y;
                var D = A * (B / C);

                var p = new PointF(triangle[0].X - D, triangle[1].Y);

                yield return new[] { triangle[0], triangle[1], p  };
                yield return new[] { triangle[1], p, triangle[2] };
                yield break;
            }

            throw new Exception("Should never happen!");

        }

        static Random randonGen = new Random();
        public static Color RandomColor()
        {
            return Color.FromArgb(randonGen.Next(256), randonGen.Next(256), randonGen.Next(256));
        }
    }

    public class Div
    {
        /// <summary>
        /// See http://apps.eky.hk/css-triangle-generator/
        /// </summary>
        public static Div FromTriangle(Color color, PointF[] triangle)
        {
            if (triangle.IsSmall()) return new Div();
            if (triangle.IsBottomRight()) return BottomRight(color, triangle);
            if (triangle.IsBottomLeft()) return BottomLeft(color, triangle);
            if (triangle.IsTopRight()) return TopRight(color, triangle);
            if (triangle.IsTopLeft()) return TopLeft(color, triangle);
            // Cannot convert non-right triangle to Div
            return new Div();
        }

        public static Div TopLeft(Color color, PointF[] triangle)
        {
            return new Div
            { Color = string.Format("#{0:X2}{1:X2}{2:X2} transparent transparent transparent", color.R, color.G, color.B)
            , Width = string.Format("{1}px {0}px 0 0", triangle[1].X - triangle[0].X, triangle[2].Y - triangle[0].Y)
            , Left = string.Format("{0}px", triangle[0].X)
            , Top = string.Format("{0}px", triangle[0].Y)
            };
        }

        public static Div TopRight(Color color, PointF[] triangle)
        {
            return new Div
            { Color = string.Format("transparent #{0:X2}{1:X2}{2:X2} transparent transparent", color.R, color.G, color.B)
            , Width = string.Format("0 {0}px {1}px 0", triangle[2].X - triangle[0].X, triangle[2].Y - triangle[0].Y)
            , Left = string.Format("{0}px", triangle[0].X)
            , Top = string.Format("{0}px", triangle[0].Y)
            };
        }

        public static Div BottomLeft(Color color, PointF[] triangle)
        {
            return new Div
            { Color = string.Format("transparent transparent transparent #{0:X2}{1:X2}{2:X2}", color.R, color.G, color.B)
            , Width = string.Format("{1}px 0 0 {0}px", triangle[2].X - triangle[0].X, triangle[2].Y - triangle[0].Y)
            , Left = string.Format("{0}px", triangle[0].X)
            , Top = string.Format("{0}px", triangle[0].Y)
            };
        }

        public static Div BottomRight(Color color, PointF[] triangle)
        {
            return new Div
            { Color = string.Format("transparent transparent #{0:X2}{1:X2}{2:X2} transparent", color.R, color.G, color.B)
            , Width = string.Format("0 0 {1}px {0}px", triangle[0].X-triangle[1].X, triangle[2].Y-triangle[0].Y)
            , Left = string.Format("{0}px", triangle[1].X)
            , Top = string.Format("{0}px", triangle[0].Y)
            };
        }

        
        public override string ToString()
        {
            if (Color == null) return "";

            return string.Format(
@"<div
style=""width: {0}; height: {1}; border-style: {2}; border-width: {3}; border-color: {4}; position:absolute; left: {5}; top: {6};""
>
</div>", "0px", "0px", "solid", Width, Color, Left, Top);
        }

        public string Color { get; private set;  }
        public string Width { get; private set; }
        public string Top { get; private set; }
        public string Left { get; private set; }
    }
}
