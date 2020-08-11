# Created by: mlleg
# Created on: 06.08.2020

library(tidyverse)

#### Variation ####
?diamonds
#1
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = z))
#we might need to play with coord_cartesian(xlim, ylim) to spot the outliers

#2
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100) +
  coord_cartesian(xlim = c(1000, 2500))
#there is a surprising drop at 1500$
# otherwise, the price distribution seems plausible as there are a lot of diamonds low priced
# and as the price increases, the number of diamons decreases (less diamons of very high quality)

#3
ggplot(data = diamonds, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
  #coord_cartesian(xlim = c(2.5, 5), ylim = c(0, 100))

diamonds %>%
  count(cut_width(carat, 0.5))

diamonds %>%
  filter(carat == 1) %>%
  count()
#there are 23 diamonds w/ carat=0.99 and 1558 w/ carat=1

#4
ggplot(data = diamonds, mapping = aes(x = x)) +
  geom_histogram() +
  ylim(0, 6000)
#coord_cartesian(xlim, ylim) zooms into the histogram,
# while xlim()/ylim() removes observations outside of the boundaries

#### Covariation ####
#1
nycflights13::flights %>%
  mutate(
  cancelled = is.na(dep_time),
  sched_hour = sched_dep_time %/% 100,
  sched_min = sched_dep_time %% 100,
  sched_dep_time = sched_hour + sched_min / 60
  ) %>%
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) +
  geom_freqpoly(
  mapping = aes(color = cancelled),
  binwidth = 1/3
  )
# add y = ..density.. to neutralize the proportion bias

#2
diamonds %>%
  ggplot(mapping = aes(x = clarity, y = price)) +
  geom_point(mapping = aes(alpha = 0.1)) +
  geom_smooth(se = FALSE)

diamonds %>%
  ggplot(mapping = aes(x = clarity, y = price)) +
  geom_boxplot()

#3
library(ggstance)
mpg %>%
  ggplot(mapping = aes(class, hwy, fill = factor(cyl))) +
  geom_boxplot() +
  coord_flip()

mpg %>%
  ggplot(mapping = aes(hwy, class, fill = factor(cyl))) +
  geom_boxploth()

#5
diamonds %>%
  ggplot(mapping = aes(x = price, y = cut)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75))

diamonds %>%
  ggplot(mapping = aes(x = price)) +
  geom_histogram(binwidth = 100)

diamonds %>%
  ggplot(mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 200)

#######
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = n))

#######
smaller <- diamonds %>%
  filter(carat < 3)

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = TRUE)

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

#2
ggplot(data = diamonds, aes(x = carat)) +
  geom_freqpoly(mapping = aes(group = cut_width(price, 500)))
