library(plyr)
library(tidyverse)


# Create Primary Key for 2d data ------------------------------------------

fpath <- "D:/My Documents/Casts/cast_workflow/2d_data_original.csv"
data_2d <- read_csv(fpath)

df1 <- data_2d %>%
            separate(Dataset, into = c("root", "path1", "cast",
                                       "path2", "path3", "VOI", "basename"), 
                     sep = "\\\\") %>%
            separate(basename, into = c("cast_segment", "rec", 
                                        "voi", "segment_number"),
                     sep = "_") %>%
            separate(VOI, into = c("VOI", "sub_segment"), sep = "_") %>%
            mutate_at(vars(matches("sub_segment")), as.integer) %>%
            select(-root, -path1, -path2, -path3, -VOI, -rec, -voi, -segment_number) %>%
            select(cast, cast_segment, sub_segment, everything())

# extract z-position information from 3d data -----------------------------

ExtractZstats <- function(file_name) {
  z_data <- read_csv(file_name, 
                     skip = 8, 
                     n_max = 6, 
                     col_names = c("label", "start", "end"))
  
  z_data <- z_data %>%
    filter(label %in% c("Z-position range of VOI", "Pixel size (um)"))
  
  z_data <- z_data %>%
    mutate(z.start = start, 
           z.end = end, 
           pixel.size = subset(z_data, label == "Pixel size (um)")$start) %>%
    filter(label == "Z-position range of VOI") %>%
    select(z.start, z.end, pixel.size)
  
}

fpath <- "D:/Dropbox/Casts/Casts/Cast Data/Excel_data_files/3d_data/batman_files/segments/"
z_data <- plyr::ldply(.data = list.files(path = fpath, full.names = TRUE, pattern = "*.csv"),
                      .fun  = ExtractZstats)

file_names <- list.files(fpath)
new_df <- z_data %>%
  mutate(file.name = tools::file_path_sans_ext(file_names)) %>%
  separate(file.name, into = c("cast.id", 
                               "nonsense1", 
                               "nonsense2", 
                               "segment_batman"), 
           sep = "_") %>%
  separate(segment_batman, into = c("nonsense1", "segment")) %>%
  select(cast.id, segment, z.start, z.end, pixel.size) %>%
  mutate(segment.length = (z.end - z.start) * pixel.size)

write_csv(new_df, "cast_ZData.csv")


# read in both csv files and join on cast_segment number ------------------

df2 <- read_csv("D:/My Documents/Casts/cast_workflow/z_data.csv")

combined_df <- full_join(df1, df2, by = c("cast_segment" = "cast.id", 
                                          "sub_segment" = "segment")) %>%
                select(cast, cast_segment, sub_segment, z.start, z.end, segment.length, everything())


write_csv(combined_df, "2d_data.csv")
