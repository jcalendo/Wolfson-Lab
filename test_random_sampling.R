# test random points for alv thickness macro ------------------------------
library(tidyverse)


files <- c("test_pts_100.csv", "test_pts_500.csv", "test_pts_1000.csv")

# create list of dataframes
dfs <- map(files, read_csv)

# perform cleaning operations on all dataframes
result <- map(dfs, ~ filter(., Mean != 0)) %>% 
  map(~ select(., Label, Mean)) %>% 
  map(~ separate(., Label, 
                 sep = "-", 
                 into = c("AnimalID", "Location", "ImgNum"), 
                 extra = "drop")) %>% 
  map(~ group_by(., AnimalID, Location, ImgNum)) %>% 
  map(~ summarize(., mean_thickness = mean(Mean),
                  sd_thickness = sd(Mean),
                  n()))

# write output to csv files
write_csv(as.data.frame(result[1]), "100_pts_summary.csv")
write_csv(as.data.frame(result[2]), "500_pts_summary.csv")
write_csv(as.data.frame(result[3]), "1000_pts_summary.csv")