input =  getDirectory("Choose Source Directory");   
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
  run("Measure");
  updateResults();
  run("Close All");
  saveAs("Results", output + "NeuN Stain Area.xls");

}
