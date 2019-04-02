# Commands for working with microCT PFC lung data
##############################################################################
library(tidyverse)


##############################################################################
#               Merging 2d and 3d data into one dataset
##############################################################################

# 2d_data and 3d_data are csv files containing the raw data from the ct analysis
# as well as metadata about each animal analyzed. These csv files were created 
# in MS Excel by using VLOOKUP to assign metadata to each animal based on their
# animal_id as well as by parsing the filename to obtain variables cooresponding 
# to the Region and VOI_Method
data_2d <- read_csv("2d_data.csv")
data_3d <- read_csv("3d_data.csv")

# eliminate M1_MCFILL_PFOB from both datasets -- not a typical sample
data_2d <- data_2d %>% filter(Animal_ID != "M1_MCFILL_PFOB")
data_3d <- data_3d %>% filter(Animal_ID != "M1_MCFILL_PFOB")

# select out relevant columns to reduce the sizes of each dataset
trim_2d <- data_2d %>% select(Animal_ID:VOI_Method, 
                              "Mean total crossectional object area":"Average object area-equivalent circle diameter per slice")
trim_3d <- data_3d %>% select(Animal_ID:VOI_Method,
                              Object_volume,
                              Percent_object_volume,
                              "Object surface_volume ratio"
                              )

# join both datasets - use full join to include all data from both datasets
#  some 2d data processed that was not processed for rat and vice versa
joined_data <- full_join(trim_2d, trim_3d, by = c("Animal_ID" = "Animal_ID",
                                                  "Species" = "Species", 
                                                  "Side" = "Side", 
                                                  "Smoke" = "Smoke", 
                                                  "Poly_IC" = "Poly_IC", 
                                                  "Airway_media" = "Airway_media",
                                                  "Vasculature_media" = "Vasculature_media", 
                                                  "PFC_type" = "PFC_type", 
                                                  "Object_measured" = "Object_measured",
                                                  "Region" = "Region", 
                                                  "VOI_Method" = "VOI_Method"))

write_csv(joined_data, "all_data_combined.csv")

##############################################################################
#                        Group and Summarize data
##############################################################################

# filter out the second cohort of animals to be consistent with excel PivotTable
# The second cohort was only mice so this filtering does not apply when defining
# Meths_rat (Species == "RAT" assures this)
cohort_2 <- c("M1_MCFILL_AIR", "M1_MCFILL_PFOB", "M1_MCFILL_PP2", "M1_MCFILL_PP9", "M1_PFOB",
"M1_PP2", "M1_PP9", "M2_PFOB", "M2_PP2", "M2_PP9")

Meths_mouse <- filter(data_2d,
                      !Animal_ID %in% cohort_2,
                      Species == "MOUSE",
                      Airway_media == "AIR")

Meths_rat <- filter(data_2d,
                    Species == "RAT",
                    Airway_media == "AIR")

# filter into groups of interest
Meths_mouse_all <- Meths_mouse %>%
                   filter(Object_measured == "ALL_TISSUE")

Meths_mouse_all_ra <- Meths_mouse_all %>%
                      filter(Smoke == "FALSE")

Meths_mouse_all_smoke <- Meths_mouse_all %>%
                         filter(Smoke == "TRUE")

Meths_mouse_alv <- Meths_mouse %>%
                   filter(Object_measured == "ALVEOLI")

Meths_mouse_alv_ra <- Meths_mouse_alv %>%
                      filter(Smoke == "FALSE")

Meths_mouse_alv_smoke <- Meths_mouse_alv %>%
                          filter(Smoke == "TRUE")

Meths_mouse_micro <- Meths_mouse %>%
                    filter(Object_measured == "MICROFIL")

Meths_mouse_micro_ra <- Meths_mouse_micro %>%
                        filter(Smoke == "FALSE")

Meths_mouse_micro_smoke <- Meths_mouse_micro %>%
                          filter(Smoke == "TRUE")

Meths_mouse_parench <- Meths_mouse %>%
                      filter(Object_measured == "PARENCHYMA")

Meths_mouse_parench_ra <- Meths_mouse_parench %>%
                          filter(Smoke == "FALSE")

Meths_mouse_parench_smoke <- Meths_mouse_parench %>%
                            filter(Smoke == "TRUE")

Meths_rat_all <- Meths_rat %>%
                filter(Object_measured == "ALL_TISSUE")

Meths_rat_all_ra <- Meths_rat_all %>%
                    filter(Smoke == "FALSE")

Meths_rat_all_smoke <- Meths_rat_all %>%
                      filter(Smoke == "TRUE")

Meths_rat_alv <- Meths_rat %>%
                filter(Object_measured == "ALVEOLI")

Meths_rat_alv_ra <- Meths_rat_alv %>%
                    filter(Smoke == "FALSE")

Meths_rat_alv_smoke <- Meths_rat_alv %>%
                      filter(Smoke == "TRUE")

Meths_rat_micro <- Meths_rat %>%
                  filter(Object_measured == "MICROFIL")

Meths_rat_micro_ra <- Meths_rat_micro %>%
                      filter(Smoke == "FALSE")

Meths_rat_micro_smoke <- Meths_rat_micro %>%
                        filter(Smoke == "TRUE")

Meths_rat_parench <- Meths_rat %>%
                    filter(Object_measured == "PARENCHYMA")

Meths_rat_parench_ra <- Meths_rat_parench %>%
                        filter(Smoke == "FALSE")

Meths_rat_parench_smoke <- Meths_rat_parench %>%
                          filter(Smoke == "TRUE")

# group all datasets into a two separate collections
# since grouping will be performed based on smoking and room air
# it is necessary to separate those groups where grouping by smoke is
# unimportant, i.e. the Meths_..._all groups
data_list_all <- list(Meths_mouse_all = Meths_mouse_all, 
                  Meths_mouse_alv = Meths_mouse_alv, 
                  Meths_mouse_micro = Meths_mouse_micro, 
                  Meths_mouse_parench = Meths_mouse_parench, 
                  Meths_rat_all = Meths_rat_all,
                  Meths_rat_alv = Meths_rat_alv, 
                  Meths_rat_micro = Meths_rat_micro,
                  Meths_rat_parench = Meths_rat_parench)

data_list_smoke <- list(Meths_mouse_all_ra = Meths_mouse_all_ra, 
                        Meths_mouse_all_smoke = Meths_mouse_all_smoke,
                        Meths_mouse_alv_ra= Meths_mouse_alv_ra, 
                        Meths_mouse_alv_smoke = Meths_mouse_alv_smoke,
                        Meths_mouse_micro_ra = Meths_mouse_micro_ra, 
                        Meths_mouse_micro_smoke = Meths_mouse_micro_smoke,
                        Meths_mouse_parench_ra = Meths_mouse_parench_ra, 
                        Meths_mouse_parench_smoke = Meths_mouse_parench_smoke,
                        Meths_rat_all_ra = Meths_rat_all_ra, 
                        Meths_rat_all_smoke = Meths_rat_all_smoke,
                        Meths_rat_alv_ra = Meths_rat_alv_ra, 
                        Meths_rat_alv_smoke = Meths_rat_alv_smoke,
                        Meths_rat_micro_ra = Meths_rat_micro_ra, 
                        Meths_rat_micro_smoke = Meths_rat_micro_smoke,
                        Meths_rat_parench_ra = Meths_rat_parench_ra, 
                        Meths_rat_parench_smoke = Meths_rat_parench_smoke)

# define a group and summarize function to create summary statistics
# for each dataset. The function takes a dataset and a vector of column 
# names as input and returns the summarized dataframe based on the grouping
# defined by the column vector
group_and_summarize <- function(dataset, grp_vector) {
  grp_cols <- lapply(grp_vector, as.symbol)
  summarized <- dataset %>%
    group_by(.dots=grp_cols) %>%
    summarise_if(is.numeric,
                 funs(mean(., na.rm = TRUE),
                      sd(., na.rm = TRUE)))
  return(summarized)
}

# define the two group column vectors
# keeping separate groupings for Meths..._all and Meths_..._smoke/ra
grps_all <- c("Species", "Side", "Region", "VOI_Method")
grps_smoke <- c("Species", "Smoke", "Side", "Region", "VOI_Method")

# write each dataframe from "all" dataframes to csv files
for (i in names(data_list_all)) {
  filename = paste0(i, ".csv")
  write.csv(data_list_all[[i]], filename, row.names = FALSE)
  
  grp_summary <- group_and_summarize(data_list_all[[i]], grps_all)
  summary_fname <- paste0("summary_stats - ", i, ".csv")
  write.csv(grp_summary, summary_fname, row.names = FALSE)
}

# write each dataframe from "smoke" dataframes to csv files
for (i in names(data_list_smoke)) {
  filename = paste0(i, ".csv")
  write.csv(data_list_smoke[[i]], filename, row.names = FALSE)
  
  grp_summary <- group_and_summarize(data_list_smoke[[i]], grps_smoke)
  summary_fname <- paste0("summary_stats - ", i, ".csv")
  write.csv(grp_summary, summary_fname, row.names = FALSE)
}
