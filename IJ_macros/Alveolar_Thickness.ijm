// get the image filename - later written to Results
file_name = File.nameWithoutExtension

// Subtract background from the original image
// ADJUST rolling=... IF NOT USING 10X IMAGE
run("Subtract Background...", "rolling=200 light");

// convert to 8-bit 
run("8-bit");

// Auto threshold with Otsu thresholding
run("Auto Threshold", "method=Otsu");

// eliminate small holes within the septa
// ADJUST radius=... IF NOT USING A 10X IMAGE
run("Morphological Filters", "operation=Closing element=Disk radius=5");

// eliminate small speckles within the airspaces
// ADJUST pixel=... IF NOT USING 10X IMAGE
run("Area Opening", "pixel=100");

// run the local thickness plugin
// threshold=1 because these are binary images
run("Local Thickness (complete process)", "threshold=1");

// get dimensions of the open image
getDimensions(x, y, ch, slice, frame)

// randomly generate test points within the image
n = 100;  // set number of random points to be generated
for (i = 0; i < n; i++) {
	x1 = random() * x;
	y1 = random() * y;
	makePoint(x1, y1); // generate random point
	roiManager("Add"); // add the point to the ROI Manager
}

/* set measurements
* the mean gray value in the local thickness plugin gives the 
* diameter of the largest inscribed circle in PIXELS
*/ 
run("Set Measurements...", "mean limit redirect=None decimal=3");

// get measurements from the points
roiManager("Measure");

// Add filename column to the results - this step is different than batch processing macro
for (row=0; row < nResults; row++) {
	setResult("FileName", row, file_name);
}
updateResults();

// copy results to clipboard
String.copyResults();
String.copyResults();

// now just paste the data into an open Excel spreadsheet
