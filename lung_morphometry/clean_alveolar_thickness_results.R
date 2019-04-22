# Gennaro Calendo
# 2019-04-17
# clean alveolar thickness output files  ----------------------------------

library(tidyverse)
library(writexl)


# get list of alveolar thickness results ON THE DESKTOP!!
files <- list.files(path = "D:\\Desktop", pattern = "*Alveolar_Thickness_Results.csv", full.names = TRUE)

# check that list is not empty
if (length(files) > 0) {
  dfs <- map(files, read_csv)
} else {
  stop("There are no files ending in 'Alveolar_Thickness_Results.csv' on the Desktop")
}


# create processing functions ---------------------------------------------

process_automatic = function(df) {
  # create sheet that includes all measured points - raw data
  all_points <- df %>% 
    filter(Mean != 0) %>% 
    select(Label, Mean) %>% 
    mutate(Excess = str_extract(Label, pattern = "-Closing-areaOpen_LocThk.*"),
           Filename = str_remove(Label, pattern = Excess)) %>% 
    select(Filename, Mean) %>% 
    rename("Thickness_px" = "Mean")
  
  # create sheet that group per file (iimage)
  by_filename <- all_points %>% 
    group_by(Filename) %>% 
    summarize(mean_Thickness_px = mean(Thickness_px),
              sd_Thickness_px = sd(Thickness_px),
              N = n())
  
  # create list of results dfs for output Excel file
  output_to_xl <- list("all_points" = all_points, "per_image_summary" = by_filename)
  output_to_xl
}


process_manual = function(df) {
  all_points <- df %>% 
    filter(Mean != 0) %>% 
    select(FileName, Mean) %>% 
    rename("Thickness_px" = "Mean")
  
  by_filename <- all_points %>% 
    group_by(FileName) %>% 
    summarize(mean_Thickness_px = mean(Thickness_px),
              sd_Thickness_px = sd(Thickness_px),
              N = n())
  
  output_to_xl <- list("all_points" = all_points, "per_image_summary" = by_filename)
  output_to_xl
}


# bind dfs and clean ------------------------------------------------------
df <- bind_rows(dfs)

# check to see if file was created manually
# if so, FileName is already in df
df_names <- colnames(df)
if ("FileName" %in%  df_names & "Mean" %in% df_names) {
  out <- process_manual(df)
} else {
  out <- process_automatic(df)
}

# Finally, write the Excel file to the desktop
write_xlsx(out, path = "D:\\Desktop\\Alveolar_Thickness_Results.xlsx")

message("\nFinished: Check Desktop for Results")






  
