// name brightfield image "Brightfield", darkfield image "Darkfield" and the specimen image "Specimen"
// process for correcting uneven background illumination
// the operation consists of calculating the transmittance thought the specimen
// Corrected_image = (Specimen - Darkfield) / (Brightfield - Darkfield) * 255

brightfield = getDirectory("Select Brightfield Image");
darkfield = getDirectory("Select Darkfield Image");
specimen = getDirectory("Select Specimen Folder");

open(brightfield);
rename("Brightfield");

open(darkfield);
rename("Darkfield");

open(specimen);
rename("Specimen");

// compensate for "hot pixels" in the brightfield image
imageCalculator("Subtract create", "Brightfield","Darkfield");
selectWindow ("Result of Brightfield");
rename ("Divisor");

// compensate for "hot pixels" in the darkfield image
imageCalculator("Subtract create",  "Specimen", "Darkfield");
selectWindow("Result of Specimen");
rename("Numerator");

// calculate the transmittance as the ratio of transmitted light through the specimen 
// and the incident light to produce the corrected image

run("Calculator Plus", "i1=Numerator i2=Divisor operation=[Divide: i2 = (i1/i2) x k1 + k2] k1=255 k2=0 create");
selectWindow("Result");
rename("Corrected");







