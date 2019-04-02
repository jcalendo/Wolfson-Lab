/* This macro performs the measurement of the area of an obstruction 
 * within a selection. Open an image containing bronchii, trace the 
 * inner diameter of the lumen and add to the ROI manager. run the macro.
 */

macro "Bronchial Obstruction [b]" {
	file_name = File.nameWithoutExtension
	
	run("Subtract Background...", "rolling=50 light");
	roiManager("Measure");
	run("8-bit");
	run("Auto Threshold", "method=Otsu");
	run("Set Measurements...", "area centroid perimeter shape limit redirect=None decimal=3");
	roiManager("Measure");
    // copy file name as separate row for each result
	for (row=0; row < nResults; row++) {
		setResult("FileName", row, file_name);
	}
	
	String.copyResults();
	String.copyResults();
}