library(plyr)
library(tidyverse)


# Create primary key for 3d data ------------------------------------------

fpath <- "D:/Dropbox/Casts/Casts/Cast Data/Excel_data_files/3d_data/cast_3d_data(raw output).csv"
data_3d <- read_csv(fpath)

df1 <- data_3d %>%
        separate(Dataset, 
                 into = c("root", "path1", "cast",
                          "path2", "path3", "VOI", "basename"), 
                 sep = "\\\\") %>%
        separate(basename, 
                 into = c("cast_segment", "rec", 
                          "voi", "segment_number"),
                 sep = "_") %>%
        separate(VOI, into = c("VOI", "sub_segment"), sep = "_") %>%
        mutate_at(vars(matches("sub_segment")), as.integer) %>%
        select(-root, -path1, -path2, -path3, -VOI, -rec, -voi, -segment_number) %>%
        select(cast, cast_segment, sub_segment, everything())


# full join with cast ZData -----------------------------------------------

df2 <- read_csv("D:/My Documents/Casts/cast_workflow/z_data.csv")

combined_df <- full_join(df1, df2, by = c("cast_segment" = "cast.id", 
                                          "sub_segment" = "segment")) %>%
               select(cast, cast_segment, sub_segment, z.start, z.end, segment.length, everything())

write_csv(combined_df, "3d_data.csv")
