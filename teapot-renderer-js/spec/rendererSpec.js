describe("the parse functions", function() {

	it("should be able to parse a coordinate", function() {
		expect(parseCoordinate(new Array(0.4, 0.6))).toEqual(new Point(0.4, 0.6));
	});
	
	it("should be able to parse a point", function() {
		expect(parsePoint("12,8")).toEqual(new Point(12, 8));
	});
	
	it("should be able to parse a line", function() {
		expect(parseLine("\"{0,200}\",\"{0,200}\",\"{0,200}\"")).toEqual(
				new Triangle(new Array(new Point(0, 200), new Point(0, 200), new Point(0, 200))));
	});
	
	it("should be able to parse several lines", function() {
		var input = new Array(
				"\"{0,300}\",\"{0,300}\",\"{0,300}\"",
				"\"{0,200}\",\"{0,200}\",\"{0,200}\"",
				"\"{0,100}\",\"{0,100}\",\"{0,100}\""
		);
		expect(readInput(input)).toEqual(new Array(
				new Triangle(new Array(new Point(0,300), new Point(0, 300), new Point(0, 300))),
				new Triangle(new Array(new Point(0,200), new Point(0, 200), new Point(0, 200))),
				new Triangle(new Array(new Point(0,100), new Point(0, 100), new Point(0, 100)))
		));
	});
	
});

describe("the bounding box functions", function() {
	
	it("should be able to determine the ratio of a bounding box", function() {
		expect(ratio(new Box(-10, 10, -5, 5))).toEqual(0.5);
	});
	
	it("should be able to determine the height of a bounding box", function() {
		expect(boxHeight(new Box(-10, 10, -5, 5))).toEqual(10);
	});
	
	it("should be able to determine the width of a bounding box", function() {
		expect(boxWidth(new Box(-10, 10, -5, 5))).toEqual(20);
	});
	
	it("should be able to construct a new bounding box from two others", function() {
		expect(overlap(new Box(-10, -5, -5, -3), new Box(5, 10, 3, 5))).toEqual(new Box(-10, 10, -5, 5));
	});
	
	it("should be able to construct a bounding box from a triangle", function() {
		var triangle = new Triangle(new Array(new Point(-1,2), new Point(-3,0), new Point(3, -2)));
		expect(boundingBox(triangle)).toEqual(new Box(-3, 3, -2, 2));
	});
	
	it("should be able to construct a bounding box from an array of triangle", function() {
		var triangles = new Array(
				new Triangle(new Array(new Point( -5, -5), new Point( -3, -3), new Point( -4, -4))),
				new Triangle(new Array(new Point(  5,  5), new Point(  3,  3), new Point(  4,  4))),
				new Triangle(new Array(new Point(-15, 15), new Point(-13, 13), new Point(-14, 14)))
		);
		expect(boundingBox(triangles)).toEqual(new Box(-15, 5, -5, 15));
	});
	
});

describe("the point functions", function() {
	
	var points;

	beforeEach(function() {
		points = new Array(new Point(-1, 4), new Point(4, 2), new Point(3,9));
	});
	
	it("should be able to list all Y coordinates for an array of points", function() {
		expect(yCoordinates(points)).toEqual(new Array(4, 2, 9));
	});
	
	it("should be able to list all X coordinates for an array of points", function() {
		expect(xCoordinates(points)).toEqual(new Array(-1, 4, 3));
	});
	
	it("should be able to find the lowest Y coordinate in an array of points", function() {
		expect(lowest(points)).toEqual(2);
	});
	
	it("should be able to find the highest Y coordinate in an array of points", function() {
		expect(highest(points)).toEqual(9);
	});
	
	it("should be able to find the leftest X coordinate in an array of points", function() {
		expect(leftest(points)).toEqual(-1);
	});
	
	it("should be able to find the rightest X coordinate in an array of points", function() {
		expect(rightest(points)).toEqual(4);
	});
	
});

describe("the scaling functions", function() {
	
	it("should be able to create a valid point mapper", function() {
		expect(pointMapper(80, 10, new Box(-1, 1, -1, 1))(new Point(0, 0))).toEqual(new Point(50, 50));
	});
	
	it("should be able to scale all points in a triangle", function() {
		var triangle = new Triangle(new Array(new Point(1,1), new Point(1,2), new Point(3, 1)));
		var scalar = function(point) {
			return new Point(point.x * 2, point.y * 2);
		}
		expect(scalePointsInTriangle(scalar, triangle)).toEqual(new Triangle(new Array(new Point(2,2), new Point(2,4), new Point(6,2))));
	});
	
	it("should be able to schale an array of triangles with a scalar", function() {
		var triangles = new Array(
				new Triangle(new Array(new Point( -5, -5), new Point( -3, -3), new Point( -4, -4))),
				new Triangle(new Array(new Point(  5,  5), new Point(  3,  3), new Point(  4,  4))),
				new Triangle(new Array(new Point(-15, 15), new Point(-13, 13), new Point(-14, 14)))
		);
		var scalar = function(point) {
			return new Point(point.x * 2, point.y * 2);
		}
		
		var expected = new Array(
				new Triangle(new Array(new Point(-10,-10), new Point( -6, -6), new Point( -8, -8))),
				new Triangle(new Array(new Point( 10, 10), new Point(  6,  6), new Point(  8,  8))),
				new Triangle(new Array(new Point(-30, 30), new Point(-26, 26), new Point(-28, 28)))
		);
		
		expect(scaleTrianglesWithScalar(triangles, scalar)).toEqual(expected);
	});
	
	it("should be able to create a point mapper based on a canvas and an array of triangles", function() {
		var triangles = new Array(
				new Triangle(new Array(new Point(-5,-5), new Point(-5,-5), new Point(-5, 5))),
				new Triangle(new Array(new Point( 5, 5), new Point( 5, 5), new Point( 5,-5))),
				new Triangle(new Array(new Point(-5, 5), new Point( 5, 5), new Point(-5,-5)))
		);
		expect(pointMapperBasedOnTriangles(80, 10, triangles)(new Point(0, 0))).toEqual(new Point(40, 40));
	});
	
	it("should be able to scale an array of triangles based on a canvas and padding", function() {
		var triangles = new Array(
				new Triangle(new Array(new Point(-5,-5), new Point(-5,-5), new Point(-5, 5))),
				new Triangle(new Array(new Point( 5, 5), new Point( 5, 5), new Point( 5,-5))),
				new Triangle(new Array(new Point(-5, 5), new Point( 5, 5), new Point(-5,-5)))
		);
		
		var expected = new Array(
				new Triangle(new Array(new Point(0, 0), new Point(0, 0), new Point(0, 100))),
				new Triangle(new Array(new Point(100, 100), new Point(100, 100), new Point(100, 0))),
				new Triangle(new Array(new Point(0, 100), new Point(100, 100), new Point(0, 0)))
		);
		expect(scaleTriangles(100, 0, triangles)).toEqual(expected);
	});
	
	it("should be able to calculate a viewport height to be able to resize the viewport to the correct ratio", function() {
		var triangles = new Array(
				new Triangle(new Array(new Point(-5, 0), new Point(-5, 0), new Point(-5, 5))),
				new Triangle(new Array(new Point( 5, 5), new Point( 5, 5), new Point( 5, 0))),
				new Triangle(new Array(new Point(-5, 5), new Point( 5, 5), new Point(-5, 0)))
		);
		expect(calculateViewportHeight(100, 10, triangles)).toEqual(60);
	});
	
});

describe("the triangle functions", function() {
	
	it("should be able to determine if three points are on the same x axis", function() {
		expect(findEqualX(new Triangle(new Array(new Point(0, 1), new Point(0, 2), new Point(0, 3))))).toEqual(new Array(0, 1, 2));
	});
	
	it("should be able to determine if three points are on the same y axis", function() {
		expect(findEqualY(new Triangle(new Array(new Point(0, 2), new Point(1, 2), new Point(2, 2))))).toEqual(new Array(0, 1, 2));
	});
	
	it("should be able to determine if two points are on the same x axis", function() {
		expect(findEqualX(new Triangle(new Array(new Point(0, 1), new Point(1, 2), new Point(0, 3))))).toEqual(new Array(0, 2));
	});
	
	it("should be able to determine if two points are on the same y axis", function() {
		expect(findEqualY(new Triangle(new Array(new Point(0, 1), new Point(1, 2), new Point(0, 2))))).toEqual(new Array(1, 2));
	});

	it("should be able to determine if no two points are on the same x axis", function() {
		expect(findEqualX(new Triangle(new Array(new Point(0, 1), new Point(1, 2), new Point(2, 3))))).toEqual(new Array());
	});
	
	it("should be able to determine if no two points are on the same y axis", function() {
		expect(findEqualY(new Triangle(new Array(new Point(0, 1), new Point(1, 2), new Point(2, 3))))).toEqual(new Array());
	});
	
});

describe("recursive subdivide triangle tests", function() {
	
	it("should be able to subdivide veritical triangle case 1", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(2, -2), new Point(0, 2)));
		var expected = [
		        [ new Triangle(new Array(new Point(0, 0), new Point(0, 2), new Point(1, 0))) ],
				[ new Triangle(new Array(new Point(0, 0), new Point(2, -2), new Point(1, 0))) ]
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});
	
	it("should be able to subdivide veritical triangle case 2", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(0, 6), new Point(2, 4)));
		var expected = [
				[ 
				  new Triangle(new Array(new Point(2, 4), new Point(0, 0), new Point(0, 4))),
				  new Triangle(new Array(new Point(2, 4), new Point(0, 6), new Point(0, 4))) 
				], []
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});
	
	it("should be able to subdivide veritical triangle case 3", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(2, 2), new Point(0, -2)));
		var expected = [
				[ new Triangle(new Array(new Point(0, 0), new Point(0, -2), new Point(1, 0))) ],
				[ new Triangle(new Array(new Point(0, 0), new Point(2, 2), new Point(1, 0))) ]
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});
	
	it("should be able to subdivide horizontal triangle case 1", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(2, 0), new Point(-2, -2)));
		var expected = [
				[ new Triangle(new Array(new Point(0, 0), new Point(2, 0), new Point(0, -1))) ],
				[ new Triangle(new Array(new Point(0, 0), new Point(-2, -2), new Point(0, -1))) ]
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});
	
	it("should be able to subdivide horizontal triangle case 2", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(4, 0), new Point(3, -2)));
		var expected = [ 
				[
					new Triangle(new Array(new Point(3, -2), new Point(0, 0), new Point(3, 0))),
					new Triangle(new Array(new Point(3, -2), new Point(4, 0), new Point(3, 0)))
				], []
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});

	it("should be able to subdivide horizontal triangle case 3", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(2, 0), new Point(4, -2)));
		var expected = [
				[ new Triangle(new Array(new Point(2, 0), new Point(0, 0), new Point(2, -1))) ],
				[ new Triangle(new Array(new Point(2, 0), new Point(4, -2), new Point(2, -1))) ]
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});
	
	it("should be able to subdivide abitrary triangle", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(10, 2), new Point(6, 6)));
		var expected = [ [],
				[
				 	new Triangle(new Array(new Point(0, 0), new Point(10, 2), new Point(2, 2))),
					new Triangle(new Array(new Point(10, 2), new Point(2, 2), new Point(6, 6)))
				 	
				]
		];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	});
	
	it("should filter out a triangle with two duplicate points", function() {
		var triangle = new Triangle(new Array(new Point(0, 0), new Point(6, 6), new Point(6, 6)));
		var expected = [[], []];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	})
	
	it("should filter out a triangle with three duplicate points", function() {
		var triangle = new Triangle(new Array(new Point(6, 6), new Point(6, 6), new Point(6, 6)));
		var expected = [[], []];
		expect(subdivideTriangle(triangle)).toEqual(expected);
	})
	
});



