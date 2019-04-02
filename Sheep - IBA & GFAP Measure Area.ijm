input =  getDirectory("Choose Source Directory");   
output = getDirectory("Choose Output Directory"); 
 
//This measures the area of the image stained with IBA

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++) {
  open (input + list[i]);  
   run("Subtract Background...", "rolling=50 light");
  run("Colour Deconvolution", "vectors=[User values] [r1]=0.236972611 [g1]=	0.440354387 [b1]=0.845593442 [r2]=0.495188169 [g2]=0.80424996 [b2]=	0.277433602 [r3]=0.006528996 [g3]=0.971812098 [b3]=0.232213175");
  setAutoThreshold("Default");
  //run("Threshold...");
  setAutoThreshold("Default");
  setOption("BlackBackground", false);
  run("Convert to Mask");
  run("Measure");
  updateResults();
  run("Close All");
  saveAs("Results", output + "IBA Stain Area.xls");

}

run("Clear Results");



