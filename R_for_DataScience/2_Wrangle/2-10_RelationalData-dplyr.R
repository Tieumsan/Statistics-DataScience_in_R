# Created by: mlleg
# Created on: 19.08.2020

library(tidyverse)
library(nycflights13)

#### Keys ####
# A good practice is to check that the primary keys indeed
# uniquely identify each observation
planes %>%
  count(tailnum) %>%
  filter(n > 1)

#1 (add a surrogate key)
flights %>%
  mutate(key = row_number())

#2
Lahman::Batting %>%
  count(playerID, yearID, stint) %>%
  filter(n > 1)

head(Lahman::Batting)

#### Mutating Joins ####
#1
library(maps)

head(airports)

avg_dest_delay <- flights %>%
  group_by(dest) %>%
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c('dest' = 'faa'))

avg_dest_delay %>%
  ggplot(aes(lon, lat, color = avg_delay)) +
  borders('state') +
  geom_point() +
  coord_quickmap()

#2
head(flights)
airports_locations <- airports %>%
  select(faa, lat, lon)

flights %>%
  select(year:day, origin, dest) %>%
  left_join(airports_locations, by = c('origin' = 'faa')) %>%
  left_join(airports_locations, by = c('dest' = 'faa'))

#3
plane_age <- planes %>%
  select(tailnum, plane_year = year)

flights %>%
  inner_join(plane_age, by = 'tailnum') %>%
  filter(!is.na(plane_year)) %>%
  group_by(plane_year) %>%
  mutate(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(plane_year, avg_delay)) +
  geom_point() +
  geom_smooth()

#### Filtering Joins ####
#1
flights %>%
  filter(is.na(tailnum)) %>%
  head(10)

#2
head(planes)
planes_100 <- flights %>%
  filter(!is.na(tailnum)) %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n >= 100)

flights %>%
  semi_join(planes_100, by = 'tailnum')

#5
flights %>%
  anti_join(airports, by = c('dest' = 'faa'))
#This shows us which flights went to unregistered airports
airports %>%
  anti_join(flights, by = c('faa' = 'dest'))
#This shows us which airports are not flought from/to by any flight in the flights table

#6
head(flights)
flights %>%
  filter(!is.na(tailnum)) %>%
  distinct(tailnum, carrier) %>%
  group_by(tailnum) %>%
  filter(n() > 1) %>%
  left_join(airlines, by = 'carrier') %>%
  arrange(tailnum, carrier)

