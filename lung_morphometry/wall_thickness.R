# test random points for alv thickness macro ------------------------------
library(tidyverse)


files <- c("Apex_Alveolar_Thickness_Results.csv", 
           "Lateral_Alveolar_Thickness_Results.csv", 
           "N_Alveolar_Thickness_Results.csv")

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
                  N = n())) 

# combine raw data into per image results ---------------------------------
per_image_df <- bind_rows(result) %>% 
  rename(Location_Code = Location) %>% 
  mutate(Location = case_when(str_detect(Location_Code, "A") ~ "Apex",
                              str_detect(Location_Code, "L") ~ "Lateral",
                              str_detect(Location_Code, "N1|N2") ~ "Medial",
                              str_detect(Location_Code, "N3") ~ "Base",
                              str_detect(Location_Code, "N4") ~ "Lateral")) %>% 
  write_csv("per_image_Alveolar_Thickness.csv")

# combine per image results to summarize by animalID and location ---------
by_animalID_location <- per_image_df %>% 
  group_by(AnimalID, Location) %>% 
  summarize(mean_Thickness_px = mean(mean_thickness, na.rm=TRUE),
            sd_thickness_px = sd(mean_thickness, na.rm=TRUE),
            N = n()) %>% 
  mutate(mean_Thickness_um = mean_Thickness_px / 2.0969,
         sd_thickness_px = sd_thickness_px / 2.0969)

write_csv(by_animalID_location, "per_animal_Alveolar_Thickness.csv")


# assign groups and plot --------------------------------------------------

dict <- read_csv("dictionary.csv")

with_assignments <- by_animalID_location %>% 
  left_join(dict, by = c("AnimalID" = "Animal_ID"))

# exploratory plot
ggplot(with_assignments) +
  stat_boxplot(mapping = aes(x = reorder(treatment, mean_Thickness_um, FUN = median),
                             y = mean_Thickness_um),
               geom ='errorbar', 
               width = 0.2) +
  geom_boxplot(mapping = aes(x = reorder(treatment, mean_Thickness_um, FUN = median), 
                   y = mean_Thickness_um),
               outlier.color = "red") +
  ggtitle("Mean Alveolar Thickness by Treatment Group") +
  xlab(NULL) +
  ylab("um") + 
  theme_bw()
