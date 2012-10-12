#!/usr/bin/env python3
import sys

# Return a copy of string without any chars in CHARSET in the copy
def removeFromString(string, charset):
    return "".join([c for c in string if c not in charset])

# Returns a triangle (which is represented as a list of coordinate
# tuples) based on the numbers in NUMLIST.
def parseTriangle(numlist):
    # print("numlist/splitline: {}".format(numlist))
    xs, ys, isXCoord = [], [], True
    scale_factor = 500
    x_offset, y_offset = 0, -400
    for num in [scale_factor*float(s) for s in numlist]:
        if isXCoord: xs.append(num + x_offset)
        else: ys.append(num + y_offset)
        isXCoord = not isXCoord
    return tuple(zip(xs, ys))

def indent(level, line):
    return level * "  " + line + "\n"

def writeTriangles(indentLevel, fileHandle, triangles):
    fileHandle.write(indent(indentLevel, "triangleList = {}".format(triangles)))

def writeHaskellFile(filename, triangleList):
    dest = open(filename, 'w+')
    dest.write(indent(0, 'module RawTriangleData ('))
    dest.write(indent(1, 'triangles,'))
    dest.write(indent(1, 'triangleList'))
    dest.write(indent(0, ') where'))
    dest.write("\n")
    dest.write(indent(0, 'import GHC.Float'))
    dest.write(indent(0, 'import Data.List'))
    dest.write(indent(0, 'import Graphics.Gloss'))
    dest.write(indent(0, 'import Graphics.Gloss.Data.Point'))
    dest.write("\n")
    writeTriangles(0, dest, triangleList)
    dest.write("\n")
    dest.write(indent(0, 'triangles :: [((Double, Double), (Double, Double), (Double, Double))] -> [(Point, Point, Point)]'))
    dest.write(indent(0, 'triangles ( ((x1,y1), (x2,y2), (x3,y3)):ts )'))
    dest.write(indent(1, '| ts == [] = t'))
    dest.write(indent(1, '| otherwise = t ++ triangles ts'))
    dest.write(indent(2, 'where t = [((double2Float x1, double2Float y1), (double2Float x2, double2Float y2), (double2Float x3, double2Float y3))]'))
    dest.write("\n")
    dest.close()

source = open(sys.argv[1], 'r')
triangles = []

for line in source.readlines():
    splitline = removeFromString(line, '{}"\n ').split(',')
    triangles += (parseTriangle(splitline),)

source.close()

haskellFileName = "RawTriangleData.hs"
writeHaskellFile(haskellFileName, triangles)
print("{} written.".format(haskellFileName))