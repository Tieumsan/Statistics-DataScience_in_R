# Created by: mlleg
# Created on: 11.08.2020

rm(list = ls())
library(tidyverse)

#1
class(iris)
tb <- as_tibble(iris)
class(tb)

#2
df <- data.frame(abc = 1, xyz = 'a')
df$x
df[, 'xyz']
df[, c('abc', 'xyz')]
## tibble doesn't accept partial matching
tb <- tibble(abc = 1, xyz = 'a')
tb$xyz
tb[, 'xyz']
tb[, c('abc', 'xyz')]

#4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying$`1`
ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()

annoying$`3` <- annoying$`2` / annoying$`1`
annoying <- annoying %>% rename('one' = `1`, 'two' = `2`, 'three' = `3`)

#5
?enframe