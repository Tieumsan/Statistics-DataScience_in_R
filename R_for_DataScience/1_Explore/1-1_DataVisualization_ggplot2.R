# Title     : Part 1, Chapter 1 of R for Data Science book - Explore
# Objective : Learn the basic tools to explore a dataset
# Created by: mlleg
# Created on: 04.08.2020

rm(list = ls())
library(tidyverse)

### Chapter 1 - Data Visualization w/ ggplot2
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# by default, geom_point overplots by rounding the values so that many points overlap eachother
# On a larger scale, it is better to use geom_jitter/position='jitter' to get a better sense of where the mass of the data lies
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class), position = 'jitter')

#Exercises
ggplot(data = mpg)

?mtcars
mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = class))

# map continuous variable to color, size, shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color=displ < 5, stroke = displ))

# using facet plots the x and y by category in subplots
# facet_wrap categorize by 1 variable (discrete), while facet_grid allows to categorize by 2 variables (discrete)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ trans, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ drv)

# We can combine different geoms, assign the x, y globally and tune the geoms locally
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE)

## Statistical Transformations
#1
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = depth))

#2
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) +
  geom_col(mapping = aes(x = cut, y = carat))

#3
#Every geom_ has a stat_ associated with it

#4
#stat_smoot compute the variables y(predicted value), ymin(lower ptwise CI around mean), ymax(upper ptwise CI around mean) and se(standard error)
?stat_smooth

#5
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1))

vignette('ggplot2-specs')

## Position Adjustments
#1
#replace geom_point() by geom_jitter()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(mapping = aes(color = class))
  #geom_count()
#we can finetune the jittering by modifying the height/width parameters
# geom_count plots like a scatterplot but only maps the count of the area

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = 'dodge'
  )

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = 'fill'
  )
#change between fill/color to color the inside/the borders of the bars
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

## Coordinate Systems
ggplot(data = diamonds, mapping = aes(x = cut, fill = cut)) +
  geom_bar(width = 1) +
  theme(aspect.ratio = 1) +
  coord_polar() +
  labs(title = 'Proportion of the different cuts of diamonds', subtitle = 'in polar coordinate', caption = 'based on the book \'R for Data Science\' ')

#3
# The difference between coord_map and coord_quickmap is that
# quickmap preserves straight lines and works best for smaller areas close the the equator
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()
#coord_fixed allows to specify the ratio of change between x and y. The default is 1 (change of 1 in x = change of 1 in y)
