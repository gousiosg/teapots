
$(document).ready(
	function() {

		var container = $("#container");
		var input = $("#input");
		input.text("\"{0,200}\",\"{300,0}\",\"{600,200}\"\n"
				+ "\"{0,200}\",\"{600,200}\",\"{300,400}\"\n" 
				+ "\"{0,200}\",\"{300,400}\",\"{0,500}\"\n"
				+ "\"{300,400}\",\"{0,500}\",\"{300,700}\"\n"
				+ "\"{600,200}\",\"{300,400}\",\"{300,700}\"\n"
				+ "\"{600,200}\",\"{300,700}\",\"{600,500}\"\n");
		var canvasWidth = 600;
		var canvasPadding = 20;
		
		$("#render").click(function() {
			var colorFunction = positionalColor;
			if ($("#color").is(":checked")) {
				colorFunction = randomColor;
			}
			
			var lines = input.text().trim().split("\n");
			var triangles = scaleTriangles(canvasWidth, canvasPadding, readInput(lines));
			var canvasHeight = calculateViewportHeight(canvasWidth, canvasPadding, triangles);
			
			// Resize the viewport to make the render fit.
			container.attr("width", canvasWidth);
			container.attr("height", canvasHeight);
			
			var context = document.getElementById("container").getContext("2d");
			
			for (var j = 0; j < triangles.length; j++) {
				var triangle = triangles[j];
				
				var polygons = subdivide(triangle);
				render(context, triangle, polygons, colorFunction, canvasWidth, canvasHeight);
			}
		});
		
		function render(context, polygon, polygons, colorFunction, canvasWidth, canvasHeight) {
			context.fillStyle = colorFunction(polygon, canvasWidth, canvasHeight);
			for (var k = 0; k < polygons.length; k++) {
				var poly = polygons[k];
				
				context.beginPath();
				context.moveTo(poly.points[2].x, canvasHeight - poly.points[2].y);
				for (var i = 0; i < 3; i++) {
					context.lineTo(poly.points[i].x, canvasHeight - poly.points[i].y);
				}
				
				context.fill();
				context.closePath();
			}
		}

	}
);

// Objects

function Point(x, y) {
	this.x = x;
	this.y = y;
}

function Triangle(points) {
	this.points = points;
}

function Box(leftX, rightX, topY, bottomY) {
	this.leftX = leftX;
	this.rightX = rightX;
	this.topY = topY;
	this.bottomY = bottomY;
}

// Parser functions

function readInput(lines) {
	return prelude.map(parseLine, lines);
}

function parseLine(line) {
	return new Triangle(prelude.map(parsePoint, line.substring(2, line.length - 2).split("}\",\"{")));
}

function parsePoint(point) {
	return parseCoordinate(point.split(","));
}

function parseCoordinate(coordinate) {
	return new Point(parseFloat(coordinate[0]), parseFloat(coordinate[1]));
}

// Scaling functions.

function calculateViewportHeight(width, padding, triangles) {
	return prelude.ceiling(ratio(boundingBox(triangles)) * (width - 2*padding) + 2*padding)
}

function scaleTriangles(canvasWidth, canvasPadding, triangles) {
	return scaleTrianglesWithScalar(triangles, pointMapperBasedOnTriangles(canvasWidth, canvasPadding, triangles));
}

function pointMapperBasedOnTriangles(canvasWidth, canvasPadding, triangles) {
	return pointMapper(canvasWidth - canvasPadding * 2, canvasPadding, boundingBox(triangles));
}

function scaleTrianglesWithScalar(triangles, scalar) {
	return prelude.map(prelude.curry(scalePointsInTriangle)(scalar), triangles);
}

function scalePointsInTriangle(scalar, triangle) {
	return new Triangle(prelude.map(scalar, triangle.points));
}

// Triangle functions.

function pivotOf(triangle) {
	return triangle.points[(prelude.sum(findEqualX(triangle)) + prelude.sum(findEqualY(triangle))) - 3];
}

function uniquePoints(triangle) {
	return prelude.unique(prelude.map(function(point) { return JSON.stringify(point); }, triangle.points)).length;
}

function subdivideAll(triangles, colorFunction) {
	return prelude.fold(concat, [], prelude.map(prelude.curry(assignRandomColorToTriangles)(colorFunction), prelude.map(subdivide, triangles)));
}

function assignRandomColorToTriangles(colorFunction, triangles) {
	setColor(triangles, colorFunction);
	return triangles;
}

function setColor(triangles, colorFunction) {
	prelude.each(function(triangle) { triangle.color = colorFunction(triangles, triangle); }, triangles);
}

function subdivide(triangle) {
	var results = [];
	var toDo = [ triangle ];
	while (toDo.length > 0 && results.length < 100) {
		var result = subdivideTriangle(toDo[0]);
		results = prelude.append(results, result[0]);
		toDo = prelude.append(prelude.tail(toDo), result[1]);
	}
	return results;
}

function subdivideTriangle(triangle) {
	if (boxWidth(boundingBox(triangle)) < 1 || boxHeight(boundingBox(triangle)) < 1) {
		return [[], []];
	}
	if (uniquePoints(triangle) < 3) {
		return [[], []];
	}
	if (findEqualX(triangle).length == 2  && findEqualY(triangle).length == 2) {
		return [ [ triangle ], [] ];
	}
	
	switch (findEqualX(triangle).length) {
		case 3: return [ [triangle], [] ];
		case 2: return subdivideVerticalTriangle(sortPointsByY(triangle), findEqualX(sortPointsByY(triangle)));
	}
	switch (findEqualY(triangle).length) {
		case 3: return [ [triangle], [] ];
		case 2: return subdivideHorizontalTriangle(sortPointsByX(triangle), findEqualY(sortPointsByX(triangle)));
	}
	return subdivideArbitraryTriangle(sortPointsByY(triangle));
}

function subdivideArbitraryTriangle(triangle) {
	return [[], [
				new Triangle(new Array(triangle.points[0], triangle.points[1], calculateHorizontalSlicePoint(triangle))),
				new Triangle(new Array(triangle.points[1], calculateHorizontalSlicePoint(triangle), triangle.points[2]))
			]
	];
}

function calculateHorizontalSlicePoint(triangle) {
	return new Point(
			prelude.round((triangle.points[2].x - triangle.points[0].x) * ((triangle.points[1].y - triangle.points[0].y) / (triangle.points[2].y - triangle.points[0].y)) + triangle.points[0].x), 
			triangle.points[1].y
	);
}

function subdivideVerticalTriangle(triangle, pointsOnSameX) {
	if (arrayEqual(pointsOnSameX, new Array(1, 2))) {
		return [ 
		        [ new Triangle(new Array(triangle.points[1], triangle.points[2], calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX))) ],
				[ new Triangle(new Array(triangle.points[1], triangle.points[0], calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX))) ]
		];
	}
	else if (arrayEqual(pointsOnSameX, new Array(0, 1))) {
		return [
				[ new Triangle(new Array(triangle.points[1], triangle.points[0], calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX))) ],
				[ new Triangle(new Array(triangle.points[1], triangle.points[2], calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX))) ]
		];
	}
	else {
		return [ [
				new Triangle(new Array(triangle.points[1], triangle.points[0], calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX))),
				new Triangle(new Array(triangle.points[1], triangle.points[2], calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX)))
		], []];
	}
}

function calculateProjectionPointOnVerticalTriangle(triangle, pointsOnSameX) {
	if (arrayEqual(pointsOnSameX, new Array(0, 2))) {
		return new Point(triangle.points[0].x, triangle.points[1].y);
	}
	return new Point(
			prelude.round((triangle.points[otherPoint(pointsOnSameX)].x - triangle.points[pointsOnSameX[1]].x) * ((triangle.points[pointsOnSameX[1]].y - triangle.points[pointsOnSameX[0]].y) / (triangle.points[2].y - triangle.points[0].y)) + triangle.points[1].x),
			triangle.points[1].y
	);
}

function subdivideHorizontalTriangle(triangle, pointsOnSameY) {
	if (arrayEqual(pointsOnSameY, new Array(1, 2))) {
		return [
		        [ new Triangle(new Array(triangle.points[1], triangle.points[2], calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY))) ],
				[ new Triangle(new Array(triangle.points[1], triangle.points[0], calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY))) ]
		];
	}
	else if (arrayEqual(pointsOnSameY, new Array(0, 1))) {
		return [
				 [ new Triangle(new Array(triangle.points[1], triangle.points[0], calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY))) ],
				 [ new Triangle(new Array(triangle.points[1], triangle.points[2], calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY))) ]
		];
	}
	else {
		return [[
				new Triangle(new Array(triangle.points[1], triangle.points[0], calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY))),
				new Triangle(new Array(triangle.points[1], triangle.points[2], calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY)))
		],[]];
	}
}

function calculateProjectionPointOnHorizontalTriangle(triangle, pointsOnSameY) {
	if (arrayEqual(pointsOnSameY, new Array(0, 2))) {
		return new Point(triangle.points[1].x, triangle.points[0].y);
	}
	return new Point(
			triangle.points[1].x,
			prelude.round((triangle.points[1].y - (triangle.points[pointsOnSameY[1]].y - triangle.points[otherPoint(pointsOnSameY)].y) * ((triangle.points[pointsOnSameY[1]].x - triangle.points[pointsOnSameY[0]].x) / (triangle.points[2].x - triangle.points[0].x))))
	);
}

function concat(e1, e2) {
	return prelude.append(prelude.append([], e1), e2);
}

function otherPoint(ids) {
	return diff([0,1,2], ids)[0];
}

function arrayEqual(a1, a2) {
	if (a1.length != a2.length) {
		return false;
	}
	return diff(a1, a2).length == 0 && diff(a2, a1).length == 0;
}

function diff(haystack, subtract) {
	return haystack.filter(function(i) { return !(subtract.indexOf(i) > -1); });
}

function findEqualX(triangle) {
	if (prelude.unique(xCoordinates(triangle.points)).length == 1) {
		return new Array(0, 1, 2);
	} 
	else if (triangle.points[0].x == triangle.points[1].x) {
		return new Array(0, 1);
	} 
	else if (triangle.points[1].x == triangle.points[2].x) {
		return new Array(1, 2);
	} 
	else if (triangle.points[0].x == triangle.points[2].x) {
		return new Array(0, 2);
	} 
	else {
		return new Array();
	}
}

function findEqualY(triangle) {
	if (prelude.unique(yCoordinates(triangle.points)).length == 1) {
		return new Array(0, 1, 2);
	} 
	else if (triangle.points[0].y == triangle.points[1].y) {
		return new Array(0, 1);
	} 
	else if (triangle.points[1].y == triangle.points[2].y) {
		return new Array(1, 2);
	} 
	else if (triangle.points[0].y == triangle.points[2].y) {
		return new Array(0, 2);
	} 
	else {
		return new Array();
	}
}

function pointMapper(width, padding, box) {
	function mapX(p) {
		if (boxWidth(box) == 0) {
			return padding;
		}
		return (p.x - box.leftX) / boxWidth(box) * width + padding;
	}
	
	function mapY(p) {
		if (boxHeight(box) == 0) {
			return padding;
		}
		return (p.y - box.topY) / boxHeight(box) * width * ratio(box) + padding;
	}
	
	return function(p) {
		return new Point(mapX(p), mapY(p));
	};
}

// Point functions

function leftest(points) {
	return prelude.fold1(function(p1, p2) { return p1.x < p2.x ? p1 : p2; }, points).x;
}

function rightest(points) {
	return prelude.fold1(function(p1, p2) { return p1.x > p2.x ? p1 : p2; }, points).x;
}

function highest(points) {
	return prelude.fold1(function(p1, p2) { return p1.y > p2.y ? p1 : p2; }, points).y;
}

function lowest(points) {
	return prelude.fold1(function(p1, p2) { return p1.y < p2.y ? p1 : p2; }, points).y;
}

function xCoordinates(points) {
	return prelude.map(function(point) { return point.x; }, points);
}

function yCoordinates(points) {
	return prelude.map(function(point) { return point.y; }, points);
}

// Bounding box functions

function boundingBox(t) {
	if (t.constructor == Triangle) {
		return new Box(leftest(t.points), rightest(t.points), lowest(t.points), highest(t.points));
	}
	return prelude.fold1(overlap, prelude.map(boundingBox, t));
}

function overlap(t1, t2) {
	return new Box(
			Math.min(t1.leftX, t2.leftX), 
			Math.max(t1.rightX, t2.rightX), 
			Math.min(t1.topY, t2.topY), 
			Math.max(t1.bottomY, t2.bottomY) 
	);
}

function topLeft(box) {
	if (box.constructor == Triangle) {
		return topLeft(boundingBox(box));
	}
	return new Point(box.leftX, box.topY);
}

function topRight(box) {
	if (box.constructor == Triangle) {
		return topRight(boundingBox(box));
	}
	return new Point(box.rightX, box.topY);
}

function bottomLeft(box) {
	if (box.constructor == Triangle) {
		return bottomLeft(boundingBox(box));
	}
	return new Point(box.leftX, box.bottomY);
}

function bottomRight(box) {
	if (box.constructor == Triangle) {
		return bottomRight(boundingBox(box));
	}
	return new Point(box.rightX, box.bottomY);
}

function center(box) {
	if (box.constructor == Triangle) {
		return center(boundingBox(box));
	}
	return new Point((box.leftX + box.rightX) / 2, (box.topY + box.bottomY) / 2);
}

function boxWidth(box) {
	return box.rightX - box.leftX;
}

function boxHeight(box) {
	return box.bottomY - box.topY;
}

function ratio(box) {
	return boxHeight(box) / boxWidth(box);
}

// Sorting functions

function sortPointsInTriangles(sorter, triangles) {
	return prelude.map(sorter, triangles);
}

function sortPointsByX(triangle) {
	return new Triangle(
		triangle.points.slice().sort(
				function(p1, p2) {
					return p1.x - p2.x;
				}
		)
	);
}

function sortPointsByY(triangle) {
	return new Triangle(
		triangle.points.slice().sort(
				function(p1, p2) {
					return p1.y - p2.y;
				}
		)
	);
}

// Color functions

function randomColor(triangle, canvasWidth, canvasHeight) {
	return "rgb(" + prelude.join(',', [randomByte(), randomByte(), randomByte()]) + ")";
}

function positionalColor(triangle, canvasWidth, canvasHeight) {
	return "rgb(" + prelude.join(",", 
			prelude.replicate(3, 
					Math.min(255, Math.max(0, prelude.floor(
							(
									(
											(
													(topLeft(boundingBox(triangle)).x / canvasWidth)
											) * 0.5
									) + (
											(
													(center(boundingBox(triangle)).y / canvasHeight)
											) * 0.5
									)
							) * 200
					)))
			)
	) + ")";
}

function randomByte() {
	return prelude.floor(Math.random() * 230);
}


// Debug functions

function debugInputs(container, triangles) {
	container.empty();
	prelude.each(
			function(t) {
				container.append("<div>{ x: " + t.points[0].x + " y: " + t.points[0].y + " , x: " + t.points[1].x + " y: " + t.points[1].y + " , x: " + t.points[2].x + " y: " + t.points[2].y + " }</div>");
			}, 
			listyfy(triangles)
	);
}

function listyfy(i) {
	if (Array.isArray(i)) {
		return i;
	}
	return [ i ];
}

