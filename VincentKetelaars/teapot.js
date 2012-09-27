document.getElementById('file').addEventListener('change', handleFileSelect, false);
var tCounter = 0;
var css = document.createElement('style');
var plotWidth = 2000;
var maxValue = 1;
var negative = true;
var LIMIT = maxValue/1000;
var PRECISE = LIMIT/100;
var offset = 500;
var cssInnerHTML = "\ndiv { \nwidth:0px; \nheight:0px; } \n#main_div { \nwidth:"+Number(plotWidth)+"px; \nheight:"+Number(plotWidth)+"px; \nmargin-left:auto; \nmargin-right:auto; }";

function handleFileSelect(evt) {
	startCSS();
	var file = evt.target.files[0]; // FileList object
	var reader = new FileReader();
	reader.onload = function(evt) { 
	    var contents = evt.target.result;
		lines = contents.split("\n");
		readLines(lines);
	}	
	reader.readAsText(file);
}

function readLines() {
	for (i in lines) {
		if (lines[i]) {
			var coordstring = lines[i].match(/[-.\d]+,[\s]*[-.\d]+/g);
			var coords = [];
			for (i = 0; i < 3; i++) {
				var temp = coordstring[i].split(",");
				coords[i] = new Array(temp[0],temp[1]);				
				if (negative) coords[i] = new Array(Number(temp[0])+maxValue,Number(temp[1])+maxValue);	
			}
			var triangle = new Array(coords[0],coords[1],coords[2]);
			handleTriangle(triangle);
		}
	}
	css.innerHTML = cssInnerHTML;
}

function handleTriangle(triangle) {
	if (isTooSmall(triangle)) {	
		return;
	} else {
		if (!hasHorizontal(triangle)){
			var newTriangles = splitTriangleVertically(triangle);
			handleTriangle(newTriangles[0]);
			handleTriangle(newTriangles[1]);
			return;
	    } 
		if (!hasVertical(triangle)) {
			var newTriangles = splitTriangleHorizontally(triangle);
			handleTriangle(newTriangles[0]);
			handleTriangle(newTriangles[1]);
			return;
		} 
		drawTriangle(triangle);
	}
}

function isTooSmall(triangle) {	
	return ((distance(triangle[0], triangle[1])<LIMIT) || (distance(triangle[1], triangle[2])<LIMIT) || (distance(triangle[2], triangle[0])<LIMIT));
}

function distance(p1,p2) {
	var x = p1[0]-p2[0];
	var y = p1[1]-p2[1];
	return (Math.sqrt(Math.pow(x,2) + Math.pow(y,2)));
}

function hasHorizontal(t) {
	if (Math.abs(t[0][0]-t[1][0]) < PRECISE) return true;
	if (Math.abs(t[0][0]-t[2][0]) < PRECISE) return true;
	if (Math.abs(t[2][0]-t[1][0]) < PRECISE) return true;
}

function hasVertical(t) {
	if (Math.abs(t[0][1]-t[1][1]) < PRECISE) return true;
	if (Math.abs(t[0][1]-t[2][1]) < PRECISE) return true;
	if (Math.abs(t[2][1]-t[1][1]) < PRECISE) return true;
}

function splitTriangleHorizontally(t) {
	var newT = new Array();
	t = verticalSortedTriangle(t);
	var p4x = Number(t[0][0]) + (t[2][0]-t[0][0])*Math.abs((t[0][1]-t[1][1])/(t[0][1]-t[2][1]));
	p4 = [p4x,t[1][1]];
	newT[0] = new Array(t[0],t[1],p4);
	newT[1] = new Array(t[2],t[1],p4);
	return newT;
}

function verticalSortedTriangle(t) {
	var res = new Array();
	var p1 = t[0];
	var p2 = t[1];
	var p3 = t[2];
	if ((p1[1]==p2[1] && p1[0]<p2[0]) || (p1[1]<p2[1])){
		var pt = p1;
		p1 = p2;
		p2 = pt;
	}
	if ((p2[1]==p3[1] && p2[0]<p3[0]) || (p2[1]<p3[1])){
		var pt = p3;
		p3 = p2;
		p2 = pt;
	}
	if ((p1[1]==p2[1] && p1[0]<p2[0]) || (p1[1]<p2[1])){
		var pt = p1;
		p1 = p2;
		p2 = pt;
	}
	res = [p1,p2,p3];
	return res;
}

function splitTriangleVertically(t) {
	var newT = new Array();
	t = horizontalSortedTriangle(t);
	var p4y = Number(t[0][1]) + (t[2][1]-t[0][1])*((t[0][0]-t[1][0])/(t[0][0]-t[2][0]));
	p4 = [t[1][0],p4y];
	newT[0] = new Array(t[0],t[1],p4);
	newT[1] = new Array(t[2],t[1],p4);
	return newT;
}

function horizontalSortedTriangle(t) {
	var res = new Array();
	var p1 = t[0];
	var p2 = t[1];
	var p3 = t[2];
	if ((p1[0]==p2[0] && p1[1]<p2[1]) || (p1[0]<p2[0])){
		var pt = p1;
		p1 = p2;
		p2 = pt;
	}
	if ((p2[0]==p3[0] && p2[1]<p3[1]) || (p2[0]<p3[0])){
		var pt = p3;
		p3 = p2;
		p2 = pt;
	}
	if ((p1[0]==p2[0] && p1[1]<p2[1]) || (p1[0]<p2[0])){
		var pt = p1;
		p1 = p2;
		p2 = pt;
	}
	res = [p1,p2,p3];
	return res;
}

function startCSS() {	
	css.type = 'text/css';
	document.getElementsByTagName('head')[0].appendChild(css);	
	var main_div = document.createElement('div');
	main_div.setAttribute('id','main_div');
	document.getElementsByTagName('body')[0].appendChild(main_div);
}

function drawTriangle(triangle) {
	PIXELS = plotWidth/maxValue;
	if (negative) PIXELS = PIXELS/2;
	tCounter++;
	var div = document.createElement('div');
	div.setAttribute('id','t'+tCounter);
	document.getElementById('main_div').appendChild(div);	
	var bottomOrTop = " ";
	var borderSide = 1;	
	var t = sortTopBottomLeftRight(triangle);
	var color = "#"+randomColor();	
	var marginLeft = Number(t[0][0])*PIXELS;
	
	if (Math.abs(Number(t[1][1])-Number(t[0][1])) < PRECISE) {
		if (Math.abs(Number(t[0][0])-Number(t[2][0])) < PRECISE) {
			borderSide = Number(t[1][0]-t[0][0])*PIXELS;
			bottomOrTop = "\nborder-top: "+Number(t[0][1]-t[2][1])*PIXELS+"px; \nborder-top-color:"+color+"; \nborder-top-style:solid;";	
			showSide = "transparent";
			borderLeftRight = "\nborder-right:"+borderSide+"px solid "+showSide+";";
		} else {
			borderSide = Number(t[1][0]-t[0][0])*PIXELS;
			bottomOrTop = "\nborder-top: "+Number(t[0][1]-t[2][1])*PIXELS+"px; \nborder-top-color:"+color+"; \nborder-top-style:solid;";
			showSide = "transparent";
			borderLeftRight = "\nborder-left:"+borderSide+"px solid "+showSide+";";
		}
	} else {
		if (Number(t[0][0]-t[1][0]) < PRECISE) {
			borderSide = Number(t[2][0]-t[1][0])*PIXELS;
			bottomOrTop = "\nborder-bottom: "+Number(t[0][1]-t[1][1])*PIXELS+"px; \nborder-bottom-color:"+color+"; \nborder-bottom-style:solid;";
			showSide = "transparent";
			borderLeftRight = "\nborder-right:"+borderSide+"px solid "+showSide+";";
		} else {
			borderSide = Number(t[2][0]-t[1][0])*PIXELS;
			bottomOrTop = "\nborder-bottom:"+Number(t[0][1]-t[2][1])*PIXELS+"px; \nborder-bottom-color:"+color+"; \nborder-bottom-style:solid;";
			showSide = "transparent";
			marginLeft = Number(t[1][0])*PIXELS;
			borderLeftRight = "\nborder-left:"+borderSide+"px solid "+showSide+";";
		}
	}	
	
	var marginTop = plotWidth-Number(t[0][1])*PIXELS+offset;
	cssInnerHTML += "\n#t"+tCounter+" { \nposition:absolute; \nmargin-left:"+marginLeft+"px; \nmargin-top:"+marginTop+"px; "+borderLeftRight+" "+ bottomOrTop +" } ";
}

function sortTopBottomLeftRight(t) {
	var p1 = t[0];
	var p2 = t[1];
	var p3 = t[2];
	if ((p1[1] < p2[1] || p1[1]==p2[1] && p1[0]>p2[0])){
		var pt = p1;
		p1 = p2;
		p2 = pt;
	}
	if ((p2[1] < p3[1] || p2[1]==p3[1] && p2[0]>p3[0])){
		var pt = p3;
		p3 = p2;
		p2 = pt;
	}
	if ((p1[1] < p2[1] || p1[1]==p2[1] && p1[0]>p2[0])){
		var pt = p1;
		p1 = p2;
		p2 = pt;
	}
	return [p1,p2,p3];
}

function randomColor() {
	var z=Math.floor(Math.random()*16777215); //16777215
	return z.toString(16);
}