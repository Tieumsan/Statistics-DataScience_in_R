# Created by: mlleg
# Created on: 19.08.2020

rm(list = ls())
library(tidyverse)


#### Tidy Data ####
#2
#table2
head(table2)
cases <- table2 %>% filter(type == 'cases')
population <- table2 %>% filter(type == 'population')
cases <- cases %>% mutate(population = population$count)
cases %>% mutate(rate = count / population * 10000)
head(cases)
#table4a+table4b
head(table4a)
head(table4b)
table5_1999 <- table4a$`1999` / table4b$`1999` * 10000
table5_2000 <- table4a$`2000` / table4b$`2000` * 10000

ggplot(cases, aes(year,count)) +
  geom_point(aes(color = country)) +
  geom_line(aes(group = country))

#### Spreading & Gathering ####
stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.983, .042)
)
stocks
stocks %>%
  spread(year, return, convert = TRUE) %>%
  gather('year', 'return', `2015`:`2016`)

#4
preg <- tribble(
  ~pregnant, ~male, ~female,
  'yes',      NA,     10,
  'no',       20,     12
)
preg %>% gather('male':'female', key = 'sex', value = 'count')

#### Separating & Pull ####
?separate
tibble(x = c('a,b,c', 'd,e,f, g', 'h, i, j')) %>%
  separate(x, c('one', 'two', 'three'), extra = 'merge', remove = FALSE)

tibble(x = c('a,b,c', 'd,e', 'f,g,i')) %>%
  separate(x, c('one', 'two', 'three'), fill = 'left')
#3
?extract

#### Missing Values ####
?fill

#### Case Study ####
#We will tidy the who dataset.
#In practice we would gradually build up each step of the following complex tidying pipe
head(who) #the dataset is quite untidy and not practical to work with
dataset <- who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>%
  mutate(code = stringr::str_replace(code, 'newrel', 'new_rel')) %>%
  separate(code, c('new', 'var', 'sexage')) %>%
  select(-c(new, iso2, iso3)) %>%
  separate(sexage, c('sex', 'age'), sep = 1)

#4
head(dataset)
dataset %>%
  group_by(country, year, sex) %>%
  filter(year > 1995) %>%
  summarize(cases = sum(value)) %>%
  ggplot(aes(x = year, y = cases, group = country, color = sex)) +
  geom_line()
