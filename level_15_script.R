library(tidyverse)


taxa <- read_csv("level-15.csv")

# define a helper function that will remove columns where ALL 
# of the data is missing
ColNums_NotAllMissing <- function(df){
  as.vector(which(colSums(is.na(df)) != nrow(df)))
}

# clean up the data
taxa <- taxa %>% 
  gather(`D_0__Archaea;D_1__Crenarchaeota;D_2__Bathyarchaeia;D_3__uncultured euryarchaeote;D_4__;D_5__;D_6__;D_7__;D_8__;D_9__;D_10__;D_11__;D_12__;D_13__;D_14__`:`Unassigned;__;__;__;__;__;__;__;__;__;__;__;__;__;__`,
                        key = "sample",
                        value = "sample_count") %>%
  filter(sample_count > 0) %>%
  separate(sample, into = sprintf("D%d", 0:14), sep = ";") %>%
  rename(kingdom = D0, 
         phylum = D1, 
         class = D2,
         order = D3,
         family = D4,
         genus = D5,
         species = D6) %>%
  mutate(kingdom = str_replace(kingdom, "D_0__|__", ""),
         phylum = str_replace(phylum, "D_1__|__", ""),
         class = str_replace(class, "D_2__|__", ""),
         order = str_replace(order, "D_3__|__", ""),
         family = str_replace(family, "D_4__|__", ""),
         genus = str_replace(genus, "D_5__|__", ""),
         species = str_replace(species, "D_6__|__", ""),
         D7 = str_replace(D7, "D_7__|__", ""),
         D8 = str_replace(D8, "D_8__|__", ""),
         D9 = str_replace(D9, "D_9__|__", ""), 
         D10 = str_replace(D10, "D_10__|__", ""),
         D11 = str_replace(D11, "D_11__|__", ""),
         D12 = str_replace(D12, "D_12__|__", ""),
         D13 = str_replace(D13, "D_13__|__", ""),
         D14 = str_replace(D14, "D_14__|__", "")) %>%
  mutate_all(.funs = function(x) replace(x, which(x == ""), NA)) %>%
  select(ColNums_NotAllMissing(.))

# clean up the index column. Separate ids from date collected
# use those dates as the new `date` column
# MEB, NL, Pipe-blank and Peg-neg have dates in the reactor_num column
# DS has the string 'sample' in the reactor_num column (date is in correct column)
peg_NL_MEB_pb <- taxa %>%
  separate(index, into = c("reactor", "reactor_num", "date"), sep = "_") %>%
  filter(reactor %in% c("Peg-neg", "NL", "MEB", "Pipe-blank")) %>%
  select(-date) %>%
  rename(date = reactor_num) %>%
  mutate(date = str_replace(date, "018", "18")) %>%
  mutate(date = as.Date(date, format = "%m-%d-%y"))

DS <- taxa %>%
  separate(index, into = c("reactor", "reactor_num", "date"), sep = "_") %>%
  filter(reactor == "DS") %>%
  mutate(reactor = str_replace(reactor, "DS", "DS-Sample"),
         date = as.Date(date, format = "%m-%d-%y")) %>%
  select(-reactor_num)

AR <- taxa %>%
  separate(index, into = c("reactor", "reactor_num", "date"), sep = "_") %>%
  filter(reactor %in% c("AR", "Pipe")) %>%
  unite(col = reactor, ... = c("reactor", "reactor_num"), sep = "_") %>%
  mutate(date = as.Date(date, format = "%m-%d-%y"))

merged_df <- bind_rows(peg_NL_MEB_pb, DS, AR)

df <- merged_df %>%
  select(-Date) %>%
  separate(date, into = c("year", "month", "day"), sep = "-")


# test plot ---------------------------------------------------------------

months <- df %>%
  unite(col = "mon_year", ... = c("month", "year"), sep = "-") %>%
  group_by(`Pipe Material`, mon_year) %>%
  summarise(count = sum(sample_count))

ggplot(months) +
  geom_bar(aes(x = mon_year, y = count, fill = `Pipe Material`), 
           stat = "identity",
           position = "dodge")
