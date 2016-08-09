getSelectionCoordinates(x, y); 
l = x.length;
f = File.open("/Users/hubats01/ROI.txt");
for(i=0; i<x.length; i++)
	print(f, x[i] + "\t" + y[i]);
	