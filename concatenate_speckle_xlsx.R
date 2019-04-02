# this script will define some functions for reading and parsing the 
# speckle excel output files
# -------------------------------------------------------------------------
library(tidyverse)
library(readxl)


extract_data = function(df) {
  # grab row range where data is stored
  calc_row <- which(df == "Calculations") + 2
  perf_row <- which(df == "Mean Perfusion") - 2
  data_df <- df[calc_row:perf_row, 1:11]
  
  # fix and apply new column names to data df
  data_names <- c("side", "toi", "mean", "area_sqmm", "stdev", "points", "int_mean", "time", "duration", "auc_pus", "avg_img/s")
  colnames(data_df) <- data_names
  
  # Now use dpylr's fill function to fill in the SIDE column
  data_df <- fill(data_df, side, .direction = "down") %>% 
    drop_na(toi) %>% 
    filter(toi != "Entire rec")
  
  data_df
}

extract_pct = function(df){
  # extract row range where percent change from baseline data is stored
  start <- which(df == "Percent Change Per TOI") + 1
  end <- start + 2
  
  pct_data <- df[start:end, ]
  
  # Transpose and coerce to data frame
  pct_trans <- t(pct_data[, 2:ncol(pct_data)])
  rownames(pct_trans) <- NULL
  pct_df <- as_data_frame(pct_trans) 
  colnames(pct_df) <- unlist(pct_data[, 1])
  
  # drop "Entire Rec" row from df, shape into long format, clean "ref" if present
  pct_df <- pct_df %>% 
    filter(`%Change` != "Entire rec") %>% 
    gather(SIDE, pct_from_bl, -`%Change`) %>% 
    mutate(pct_from_bl = str_replace(pct_from_bl, "ref", "0"))
  
  pct_df
}


combine_data = function(df1, df2, subject_id) {
  # join the percent change to original dataframe 
  all_data <- left_join(df1, df2, by = c("side" = "SIDE", "toi" = "%Change")) %>% 
    add_column(subject = subject_id)
  
  all_data
}


clean_df = function(df) {
  clean_df <- df %>% 
    mutate(side = str_replace(side, "1. |2. ", "")) %>% 
    select(subject, everything())
  
  clean_df
}


  extract_subject = function(df) {
  subject <- as.character(df[which(df[1] == "Subject"), 2])
  subject
}


parse_speckle = function(infile) {
  df_raw <- read_excel(infile)
  
  subject <- extract_subject(df_raw)
  data_df <- extract_data(df_raw)
  pct_df <- extract_pct(df_raw)
  complete_df <- combine_data(data_df, pct_df, subject)
  final_df <- clean_df(complete_df)
  
  final_df
}


# main --------------------------------------------------------------------

excel_files <- list.files(pattern = "*.xlsx$")
data = lapply(excel_files, function(x) parse_speckle(x))
data_rbind <- bind_rows(data)
write_csv(data_rbind, "combined_data.csv")
