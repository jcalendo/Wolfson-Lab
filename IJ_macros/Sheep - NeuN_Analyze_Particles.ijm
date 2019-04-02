input = getDirectory("Choose Source Directory");
output = getDirectory("Choose Output Directory");
 
setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++) {
  open (input + list[i]);   
  run("Subtract Background...", "rolling=50 light");
  run("8-bit");
  run("Auto Threshold", "method=IsoData ignore_white setthreshold");
  setOption("BlackBackground", false);
  run("Convert to Mask");
  run("Despeckle");
  run("Close-");
  run("Fill Holes");
  run("Watershed");
  run("Analyze Particles...", "size=65-300 circularity=0.00-1.00 show=[Nothing] display exclude include summarize");
  run("Close All");

}

  selectWindow("Summary");
  saveAs("Results", output + "NeuN Cell Count.xls");
  run("Clear Results");


//This measures tissue area and saves the output file

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++) {
  open (input + list[i]);    
  run("8-bit");
  setThreshold(0, 254);
  run("Threshold...");
  setOption("BlackBackground", false);
  run("Convert to Mask");
  run("Measure");
  run("Close All");
	
}

  selectWindow("Results");
  saveAs("Results", output + "NeuN Tissue Area.xls");



