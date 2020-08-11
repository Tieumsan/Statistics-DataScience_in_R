# Title     : Part 1, Chapter 3 of R for Data Science book - Explore
# Objective : Learn how to transform and manipulate data w/ dplyr package
# Created by: mlleg
# Created on: 05.08.2020

rm(list = ls())
library(nycflights13)
library(tidyverse)

view(flights)

#### filter() ####
#filtering exercises
filter(flights, arr_delay >=120)
filter(flights, dest %in% c('IAH', 'HOU'))
filter(flights, carrier %in% c('UA', 'AA', 'DL'))
filter(flights, month %in% c(7, 8, 9))
filter(flights, dep_delay == 0 & arr_delay > 120)
filter(flights, between(dep_time, 0, 600))

filter(flights, is.na(dep_time)) #cancelled flights

#Explain
NA^0
NA | TRUE
NA & FALSE
NA*0
#___

#### arrange() ####
#1 - sort all missing values at the start

#2
arrange(flights, desc(dep_delay))
#3
arrange(flights, sched_arr_time)
#4
arrange(flights, desc(distance))

#### select() ####
#1
select(flights, c(dep_time, dep_delay, arr_time, arr_delay))
select(flights, dep_time:arr_delay, -c(sched_dep_time, sched_arr_time))
#2
#if we include the name of a variable multiple, it still gets selected once
select(flights, dep_time, dep_time)
#3
vars <- c('year', 'month', 'day', 'dep_delay', 'arr_delay', 'captain')
select(flights, any_of(vars))
select(flights, all_of(vars))
#4
select(flights, contains('TIME', ignore.case = FALSE))

#### mutate() ####
#1
mutate(flights,
       dep_time = ((dep_time %/% 100) * 60) + dep_time %% 100,
       sched_dep_time = (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100
)
#2
mutate(flights,
       air_time,
       eff_time = arr_time - dep_time
       )
#4
min_rank(select(flights, dep_delay))[1:10]
#5
1:3 + 1:10
#6
?Trig

#### summarize() & group_by() ####
#1

#2
not_cancelled <- flights %>%
  filter(!is.na(dep_delay) | !is.na(arr_delay)) #only !is.na(dep_delay) is more optimal (for obvious reasons)
#2.1
not_cancelled %>% count(dest)
not_cancelled %>%
  group_by(dest) %>%
  summarize(n())
#2.2
not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>%
  group_by(tailnum) %>%
  summarize(tailnum, distance)
#4
flights %>%
  group_by(year, month, day) %>%
  filter(sum(!is.na(dep_time)) > 500) %>%
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    nb_cancelled = sum(is.na(dep_time)),
    prop_cancelled = nb_cancelled / n()) %>%
  ggplot(aes(x = nb_cancelled, y = avg_delay)) +
  geom_point() +
  geom_smooth(se = FALSE)

#### mutate() & filter() ####
#3
flights %>%
  filter(!is.na(dep_time)) %>%
  summarize(
    max_delay = max(dep_delay),
    min_delay = min(dep_delay))
flights %>%
  filter(!is.na(dep_time)) %>%
  ggplot(aes(x = sched_dep_time, y = dep_delay)) +
  geom_point() +
  geom_smooth()