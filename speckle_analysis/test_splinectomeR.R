
# test spline analysis ----------------------------------------------------
library(tidyverse)
library(purrr)
library(splinectomeR)


# clean and split input data ----------------------------------------------

Speckle <- read_csv("raw_speckle_data.csv") %>% 
  filter(TOI != 'HARVEST', Treatment != 'SHAM+15') %>% 
  mutate(TOI = as.numeric(TOI)) %>% 
  filter(TOI > 0 & TOI <= 180)

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

# generate list a unique treatment combinations
trt_combinations <- combn(unique(Speckle$Treatment), 2, simplify = FALSE)

# test to see if overall trends are different -----------------------------

# define a function for permutation testing over the Speckle_Right df
perm_test_right = function(trt_list) {
  result <- permuspliner(data = Speckle_Right, x = 'TOI', y = "percent_change_BL",
                         cases = 'Rat_id', category = "Treatment",
                         groups = unlist(trt_list),
                         quiet = TRUE)
  result
}

# define a second function for testing the Left side
perm_test_left = function(trt_list) {
  result <- permuspliner(data = Speckle_Left, x = 'TOI', y = "percent_change_BL",
                         cases = 'Rat_id', category = "Treatment",
                         groups = unlist(trt_list),
                         quiet = TRUE)
  result
}

# map apply the permmutation test to all of the treatment combinations
# for both sides
right_perms <- map(trt_combinations, perm_test_right)
left_perms <- map(trt_combinations, perm_test_left)


# test whether two groups differ at any toi -------------------------------

# create sliding test function for the right side
sliding_right = function(trt_list) {
  result <- sliding_spliner(data = Speckle_Right, xvar = 'TOI',
                  yvar = 'percent_change_BL', cases = 'Rat_id',
                  category = "Treatment", groups = unlist(trt_list),
                  ints = 100, quiet = TRUE)
  result
}

# create sliding test function for the left side
sliding_left = function(trt_list) {
  result <- sliding_spliner(data = Speckle_Left, xvar = 'TOI',
                            yvar = 'percent_change_BL', cases = 'Rat_id',
                            category = "Treatment", groups = unlist(trt_list),
                            ints = 100, quiet = TRUE)
  result
}

# perform test on unique combinations of treatments
right_sliding <- map(trt_combinations, sliding_right)
left_sliding <- map(trt_combinations, sliding_left)

# plot the splines --------------------------------------------------------

pval_plot_func = function(df) {
  ggplot(df[[1]], aes(TOI, p_value)) +
  geom_point() + 
  geom_line() +
  scale_y_log10() +
  scale_x_continuous(breaks = seq(0, 180, 15)) +
  geom_hline(yintercept = 0.05, color = "red", linetype = 2) +
  ylab("pval") +
  xlab("TOI (min from impact)") + 
  theme_bw()
}

spline_plot_func = function(df) {
  ggplot(df[[3]], aes(x, value, color = category)) +
  geom_smooth(method = 'loess') +
  geom_hline(yintercept = 0, color = "red", linetype = 2) +
  scale_x_continuous(breaks = seq(0, 180, 15)) +
  xlab("TOI (min from impact)") +
  ylab("Percent Change From Baseline") +
  theme_bw()
}


# loop over results to create plots ---------------------------------------

# p_value plots
right_pval_plts <- map(right_sliding, pval_plot_func)
left_pval_plts <- map(left_sliding, pval_plot_func)

# spline plots
right_spline_plts <- map(right_sliding, spline_plot_func)
left_spline_plts <- map(left_sliding, spline_plot_func)
