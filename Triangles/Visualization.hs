-- Visualize triangles using the Gloss library

import Graphics.Gloss
import System.Random
--Custom algorithm module to decompose to right triangles (contains the Triangle type)
import Decomposition
import RawTriangleData

tupletolist3 :: (a, a, a) -> [a]
tupletolist3 (x, y, z) = [x, y, z, x]

pathFromTriangle :: Triangle -> Path
pathFromTriangle triangle = tupletolist3 triangle

picturesFromTriangles :: [Triangle] -> [Picture]
picturesFromTriangles triangles = map line (map pathFromTriangle triangles)

main = display (InWindow "Triangles" (800, 600) (10, 10)) white (color black (pictures (picturesFromTriangles (decompose (triangles triangleList)))))
