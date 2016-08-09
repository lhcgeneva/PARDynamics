run("Duplicate...", "title=Embryo1_R-1.tif duplicate range=1-49");
run("8-bit");
run("Gaussian Blur...", "sigma=4 stack");
run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize stack");
//setTool("hand");
run("Balloon");
