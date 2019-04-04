
# test spline analysis ----------------------------------------------------
library(tidyverse)
library(splinectomeR)
library(forcats)


# clean and split input data ----------------------------------------------

Speckle <- read_csv("raw_speckle_data.csv") %>% 
  filter(TOI != 'HARVEST', Treatment != 'SHAM+15') %>% 
  mutate(TOI = as.numeric(TOI)) %>% 
  filter(TOI <= 180)

Speckle_Right <- Speckle %>% 
  filter(Side == 'right') %>% 
  select(Rat_id, Treatment, TOI, percent_change_BL) %>% 
  group_by(Rat_id, Treatment, TOI) %>% 
  drop_na() %>% 
  as.data.frame()

Speckle_Left <- Speckle %>% 
  filter(Side == 'left') %>% 
  select(Rat_id, Treatment, TOI, percent_change_BL) %>% 
  group_by(Rat_id, Treatment, TOI) %>% 
  drop_na() %>% 
  as.data.frame()



# test whether two groups differ at any toi -------------------------------

## Sham vs TBI+15 
sham_vs_tbi15 <- sliding_spliner(data = Speckle_Right,
                       xvar = 'TOI',
                       yvar = 'percent_change_BL',
                       cases = 'Rat_id',
                       category = "Treatment",
                       groups = c('SHAM', 'TBI+15'),
                       ints = 100)

## Sham vs TBI+30
sham_vs_tbi30 <- sliding_spliner(data = Speckle_Right,
                                 xvar = 'TOI',
                                 yvar = 'percent_change_BL',
                                 cases = 'Rat_id',
                                 category = "Treatment",
                                 groups = c('SHAM', 'TBI+30'),
                                 ints = 100)

## sham vs tbi+60
sham_vs_tbi60 <- sliding_spliner(data = Speckle_Right,
                                 xvar = 'TOI',
                                 yvar = 'percent_change_BL',
                                 cases = 'Rat_id',
                                 category = "Treatment",
                                 groups = c('SHAM', 'TBI+60'),
                                 ints = 100)
## sham vs tbi+120
sham_vs_tbi120 <- sliding_spliner(data = Speckle_Right,
                                 xvar = 'TOI',
                                 yvar = 'percent_change_BL',
                                 cases = 'Rat_id',
                                 category = "Treatment",
                                 groups = c('SHAM', 'TBI+120'),
                                 ints = 100)

## tbi+15 vs tbi+30
tbi15_vs_tbi30 <- sliding_spliner(data = Speckle_Right,
                                  xvar = 'TOI',
                                  yvar = 'percent_change_BL',
                                  cases = 'Rat_id',
                                  category = "Treatment",
                                  groups = c('TBI+15', 'TBI+30'),
                                  ints = 100)

## tbi 15 vs tbi 60
tbi15_vs_tbi60 <- sliding_spliner(data = Speckle_Right,
                                  xvar = 'TOI',
                                  yvar = 'percent_change_BL',
                                  cases = 'Rat_id',
                                  category = "Treatment",
                                  groups = c('TBI+15', 'TBI+60'),
                                  ints = 100)

## tbi 15 vs tbi 120
tbi15_vs_tbi120 <- sliding_spliner(data = Speckle_Right,
                                  xvar = 'TOI',
                                  yvar = 'percent_change_BL',
                                  cases = 'Rat_id',
                                  category = "Treatment",
                                  groups = c('TBI+15', 'TBI+120'),
                                  ints = 100)

## tbi 30 vs 60
tbi30_vs_tbi60 <- sliding_spliner(data = Speckle_Right,
                                  xvar = 'TOI',
                                  yvar = 'percent_change_BL',
                                  cases = 'Rat_id',
                                  category = "Treatment",
                                  groups = c('TBI+30', 'TBI+60'),
                                  ints = 100)

## tbi 30 vs tbi 120
tbi30_vs_tbi120 <- sliding_spliner(data = Speckle_Right,
                                  xvar = 'TOI',
                                  yvar = 'percent_change_BL',
                                  cases = 'Rat_id',
                                  category = "Treatment",
                                  groups = c('TBI+30', 'TBI+120'),
                                  ints = 100)

## tbi 60 vs tbi 120
tbi60_vs_tbi120 <- sliding_spliner(data = Speckle_Right,
                                   xvar = 'TOI',
                                   yvar = 'percent_change_BL',
                                   cases = 'Rat_id',
                                   category = "Treatment",
                                   groups = c('TBI+60', 'TBI+120'),
                                   ints = 100)


# plot the splines --------------------------------------------------------



