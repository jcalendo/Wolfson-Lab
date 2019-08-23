# Exploratory analysis of the histomorphometry data

# -------------------------------------------------------------------------

library(tidyverse)

# histomorphometry data was extracted from the histomorphometry Excel
# workbook
df <- read_csv("C:/Users/tuc12093/Dropbox/Casts/Lung Histology/histomorphometry_and_bronchial_obstruction/scripts/data/histomorphometry_data.csv")

# Create summary stats for each treatment-animal-location group
by_treatment_animal_location <- df %>% 
  mutate(Treatment = as_factor(Treatment),
         Location = as_factor(Location)) %>% 
  group_by(Treatment, Animal_id, Location) %>% 
  summarize_if(is.numeric, 
               list(~mean(., na.rm = TRUE), ~sd(., na.rm = TRUE)))

# All locations -----------------------------------------------------------

# Only group by Treatment, ignoring separate locations
by_location <- by_treatment_animal_location %>% 
  group_by(Treatment, Location) %>% 
  summarize_if(is.numeric,
               list(~mean(., na.rm = TRUE)))

# join in the counts for this grouping
by_location_with_count <- by_treatment_animal_location %>% 
  group_by(Treatment, Location) %>% 
  count() %>% 
  left_join(by_location, by = c("Treatment", "Location"))

# create plotting function ------------------------------------------------

# general plotting function for by_location
plot_by_location = function(var_mean, var_sd) {
  ggplot(by_location, aes(Treatment, {{ var_mean }})) +
    geom_col() +
    geom_errorbar(aes(ymin = {{ var_mean }} - {{ var_sd }}, 
                      ymax = {{ var_mean }} + {{ var_sd }}), 
                  width = 0.2) +
    facet_wrap(~Location) +
    labs(x = element_blank()) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# plot and significance test ----------------------------------------------

# D2
plot_by_location(D2_mean, D2_sd)
summary(d2_res <- aov(D2_mean ~ Treatment, data = by_location))
TukeyHSD(d2_res, ordered = TRUE)
