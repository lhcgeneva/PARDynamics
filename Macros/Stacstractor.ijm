//Duplicate stack, so initial stack is still open after processing and can be compared
//to split stacks


//Enter stack dimensions
Dialog.create("Stack dimensions"); 
Dialog.addNumber("# Slice in Z:", 21); 
Dialog.addNumber("# Timepoints:", 30);
Dialog.addNumber("# Embryos:", 1);
Dialog.addNumber("# Channels:", 1);
Dialog.show();
//Assign variables from dialog
z 	= Dialog.getNumber();
t  	= Dialog.getNumber();
e 	= Dialog.getNumber();
c 	= Dialog.getNumber();

run("Duplicate...", "title=wt-005-1 duplicate range=1-"+t*z*e*c);

channel_counter = 0; //Counts number of total channels that have been stepped through to change 
						//between channel numbers

//Make substacks
for(i = 0; i < z*e*c; i++) { 	
	if (i != z*e*c-1){
		print(t*z*e*c-t*i);
		run("Make Substack...", "delete slices=1-"+t*z*e*c-t*i+"-"+(z*e*c-i));
	}

	//Calculate which embryo and which slice is processed to name file accordingly
	em = floor((i)/(z*c))+1; //embryo number
	ch 	= 1;
	sl 	= (i)%z+1; // slice number, slice calculation/names only correct for 2 channels so far
	if (sl == 1){channel_counter += 1;};
	if (channel_counter%2 == 0){ch = 2;}
	else {ch = 1;}
	
	saveAs("Tiff", "/Users/hubatsl/Desktop/tobedel/Embr" + em + "_Sl" + sl + "Ch" + ch);
	run("Close");
}
