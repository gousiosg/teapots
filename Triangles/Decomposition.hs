module Decomposition ( decompose, Triangle ) where

import Graphics.Gloss
import Data.List

type Triangle = (Point, Point, Point)

-- sorts a list of points based on the Double returned from the given function
sortByCoord :: (Point->Float)->Point->Point->Ordering
sortByCoord f a b = compare (f a) (f b)

-- returns the x coordinate of a point
xCoord :: Point -> Float 
xCoord (a,b) = a

-- returns the y coordinate of a point
yCoord :: Point -> Float
yCoord (a,b) = b

-- returns the points of a triangle
points :: Triangle -> [Point]
points (a,b,c) = [a,b,c]

-- determines if any of the points are the same after applying the given function
isStraight :: (Point->Float)->Triangle -> Bool
isStraight f t
	| f (ps !! 0) == (f (ps !! 1)) = True
	| f (ps !! 1) == (f (ps !! 2)) = True
	| otherwise = False
	where ps = sortBy (sortByCoord f) (points t)

-- shortcut to check if a triangle has 2 points with the same y
isHorizontal :: Triangle -> Bool
isHorizontal t = isStraight yCoord t

-- shortcut to check if a triangle has 2 points with the same x
isVertical :: Triangle -> Bool
isVertical t = isStraight xCoord t

-- checks if a triangle is both vertical and horizontal
isRight :: Triangle -> Bool
isRight t = isHorizontal t && isVertical t	

-- returns the point with the middle value, determined by the given function
middle :: (Point->Float)->Triangle->Point
middle f t = sortBy (sortByCoord f) (points t) !! 1

-- projects the middle horizontal point on the opposing edge, resulting in 2 triangles
-- both with 1 horizontal edge, don't call this on horizontal triangles
projectHorizontal :: Triangle -> [Triangle]
projectHorizontal t = project yCoord xCoord combineY t

-- see projectHorizontal, only this time we project vertical
projectVertical :: Triangle -> [Triangle]
projectVertical t = project xCoord yCoord combineX t


combineX :: Float->Float->Point
combineX x y = (x,y)

combineY :: Float->Float->Point
combineY y x = (x,y)

-- project the middle point to the opposing edge and return the two triangles it creates
-- f1 is the coordinate to keep steady
-- f2 is the other coordinate
-- f3 is the combine function, which will be handed the steady and the computed coordinate
project :: (Point->Float)->(Point->Float)->(Float->Float->Point)->Triangle->[Triangle]
project f1 f2 f3 t =
	[(a,b,p), (b,p,c)]
	where 
		ps = sortBy (sortByCoord f1) (points t)
		a = ps !! 0
		b = ps !! 1
		c = ps !! 2
		r = (f2 c - f2 a) / (f1 c - f1 a)
		p = f3 (f1 b) (f2 a + (f1 b - f1 a) * r)

distance :: Point -> Point -> Float
distance a b =
	sqrt ((xCoord b - xCoord a)^2 + (yCoord b - yCoord a)^2)

decomposeToHorizontal :: Triangle -> [Triangle]
decomposeToHorizontal t
	| isHorizontal t = [t]
	| otherwise = projectHorizontal t

-- decomposes until the distance treshold is met
-- FIXME treshold not implemented
decomposeToRight :: Triangle -> [Triangle]
decomposeToRight t
	| not (isHorizontal t) = concat (map decomposeToRight (projectHorizontal t))
	| isRight t = [t]
	| otherwise = concat(map decomposeToRight (projectVertical t))

decompose :: [Triangle] -> [Triangle]
decompose ts = concat (map decomposeToRight ts)
