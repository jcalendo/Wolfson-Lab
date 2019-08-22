# 2019-08-20 Gennaro Calendo
# count the number of airway generations in the bronchial obstruction data
# for each group. Display the count per group, the sd of the count and the
# sem
# -------------------------------------------------------------------------

library(tidyverse)

# Raw data can be taken from the 'obstruction_data' sheet of the 
# bronchial obstruction Excel file. Here, it was saved as a csv file
# to be read in as the original data source
df <- read_csv("C:/Users/tuc12093/Dropbox/Casts/Lung Histology/histomorphometry_and_bronchial_obstruction/scripts/data/bronchial_obstruction_data.csv")

# The first group_by counts the airway generationsfor  each animal within 
# each group
# the second group_by operation takes the mean, sd, and sem for each group
counts <- df %>% 
  group_by(Treatment, AnimalID, Type) %>% 
  summarize(N = n()) %>% 
  group_by(Treatment, Type) %>% 
  summarize(count = sum(N), 
            mean = mean(N), 
            stdev = sd(N), 
            sem = stdev / sqrt(count))
# the above 'counts' data frame was copy and pasted into the bronchial
# obstruction Excel workbook

# generate a plot ---------------------------------------------------------

# plot the count for each group in every generation
plt <- df %>% 
  group_by(Treatment, AnimalID, Type) %>% 
  summarize(N = n()) %>% 
  ggplot(aes(Treatment, N)) +
    geom_boxplot(alpha = 0) +
    geom_point(color = "red") +
    facet_wrap(~Type) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = "Count of Airways by Generation Type",
         x = element_blank(),
         y = "Count")
  
