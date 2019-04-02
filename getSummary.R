## R script for extracting summary stats from microCT data
library(dplyr)
library(plyr)

# import raw data from csv file
raw_data <- read.csv("D:/My Documents/PFC_lung_microCT/raw_data.csv")

# filter raw data to exclude PFC airway media - ensure 'M' animals are removed from imported csv
filtered_data <- filter(raw_data, 
                        Airway_media == "AIR", 
                        Vasculature_media == "MICROFIL"
                        )

# create summary stats for mouse and rat data
sdata <- ddply(filtered_data, c("Species", "Side", "Smoke", "Region",
                                "VOI_Method", "Object_measured"), 
               summarise, 
               
               N = length(Object_volume), 
               mean_ObjVol = mean(Object_volume), 
               sd_ObjVol = sd(Object_volume), 
               se_ObjVol = sd_ObjVol / sqrt(N), 
               
               mean_pctObjVol = mean(Percent_object_volume), 
               sd_pctObjVol = sd(Percent_object_volume), 
               se_pctObjVol = sd_pctObjVol / sqrt(N),
               
               mean_sVolratio = mean(Object.surface_volume.ratio),
               sd_sVolratio = sd(Object.surface_volume.ratio),
               se_sVolratio = sd_sVolratio / sqrt(N)
               
               )

# save summary stats to a new csv file
write.csv(sdata, "summary_stats.csv", row.names = FALSE)