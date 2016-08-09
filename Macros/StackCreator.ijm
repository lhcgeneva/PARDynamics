setBatchMode(true);
dirX = getDirectory("Choose Source Directory "); //Make sure directory name doesn't contain spaces
folder_list = getFileList(dirX+"/"); 
print(folder_list[0]);
l = lengthOf(folder_list);
print(l);
for (j = 0; j<l; j++) {
	print(j);
	list = getFileList(dirX+"/"+folder_list[j]); 
	file0 = list[0];
	//Timelapse
	i = j+1;
	print(dirX+folder_list[j]+file0);
	run("Image Sequence...", "open="+dirX+folder_list[j]+" file=w1488 sort");
	print("2");
	saveAs("Tiff", dirX+"/"+"Embryo"+i+"w1488.tif"); 
	run("Image Sequence...", "open="+dirX+folder_list[j]+" file=w2561 sort");
	saveAs("Tiff", dirX+"/"+"Embryo"+i+"w2561.tif"); 	
	run("Image Sequence...", "open="+dirX+folder_list[j]+" file=w3Brightfield sort");
	saveAs("Tiff", dirX+"/"+"Embryo"+i+"w3Brightfield.tif"); 
	//Z stacks
	//run("Image Sequence...", "open="+dirX+folder_list[j]+" file=w3488 sort");
	//t = nSlices/21;
	//run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=21 frames="+t+" display=Color");
	//saveAs("Tiff", dirX+"/"+"Embryo"+i+"w3488.tif");
	//run("Image Sequence...", "open="+dirX+folder_list[j]+" file=w4561 sort");
	//run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=21 frames="+t+" display=Color");
	//saveAs("Tiff", dirX+"/"+"Embryo"+i+"w4561.tif"); 
	//Close all open images
	while (nImages>0) { 
	          selectImage(nImages); 
	          close(); 
	      } 
}
