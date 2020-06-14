# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 09.06.2020

###   Hypergeometric distribution
## rhyper(nn, m, n, k) produces a vector of nn length where each
## item represent # of white balls (successes) selected when pulling k
## total balls out of a bag full of m white (success) and n black (fail) balls.
## As a result all entries of the resulting vector <= min(m,k)

##setting the seed makes the random results repeatable
set.seed(1001)

## give me # of white balls I get when pulling 3 balls out of 11 balls
## (5 black + 6 white) and do this a lot of times
m <- 6
n <- 11-m
k <- 3
hyperRes <- data.frame(successes=rhyper(330000, m, n, k))

#plot w/ ggplot2
require(ggplot2)
# fractions on labels
require(fractional)

## ggplot itself just defines the data
## geom_histogram says I want a histogram.
# aes inside turns basic counts into pmf within histogram we also pick some fancy colours
## labs does the titles - themes centers the titles
plot <- ggplot(hyperRes, aes(x=successes)) +
  geom_histogram(bins=min(m, k)+1, aes(y=..density..), color='azure', fill='azure3') +
  labs(title=sprintf('X ~ Hypergeometric distribution(%d, %d, %d)', (m+n), m, k), x='k', y='$p_(X)(k)$') +
  theme(plot.title=element_text(hjust=0.5)) + scale_y_continuous(breaks=(0:10)/20)

## now getting labels off of density calc is tricky with ggplot as it calculates
## density on the fly. So you instead can store the graph in step 1 which will store density
## then in step 2 add the labels & print on screen.
plot + geom_text(data=as.data.frame(ggplot_build(plot)$data), aes(x=x, y=density, label=fractional(density, eps=0.001)), nudge_y = 0.02)