/*
 * Alveolar Batch Processing script
 * NOTE the output of this file is a little different. The Filename of the processed
 * image is output in the results file. 
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// Main program
run("Set Measurements...", "mean limit display redirect=None decimal=3");
processFolder(input);
saveAs("Results", "D:/Desktop/Alveolar_Thickness_Results.csv");

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(list[i]);
	}
}

function processFile(infile) {
	open(infile);
	file_name = File.nameWithoutExtension;
	run("Subtract Background...", "rolling=200 light");
	run("8-bit");
	run("Auto Threshold", "method=Otsu");
	run("Morphological Filters", "operation=Closing element=Disk radius=5");
	run("Area Opening", "pixel=100");
	run("Local Thickness (complete process)", "threshold=1");
	getDimensions(x, y, ch, slice, frame);
	n = 100;  // set number of random points to be generated
	for (i = 0; i < n; i++) {
		x1 = random() * x;
		y1 = random() * y;
		makePoint(x1, y1); // generate random point
		roiManager("Add"); // add the point to the ROI Manager
	}

	roiManager("Measure");
	updateResults();
	roiManager("Delete");
    close("*");
}
