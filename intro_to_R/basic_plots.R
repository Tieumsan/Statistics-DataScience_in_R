# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 09.06.2020

library(ggplot2)
### Scatterplot ###
myData <- cars
myData
## ggplot works with layer. To add a layer to the plot: function() + function() +...
#plot
g <- ggplot(myData, aes(x=speed, y=dist)) + geom_point()
gg <- g + coord_cartesian(xlim=c(10, 20), ylim=c(10, 50))

g
gg


### Histogram ###
myData <- mtcars
#plot
h <- ggplot(myData, aes(x=wt)) + geom_histogram(binwidth=0.5, color='black', fill='white')
h

weight_mean <- mean(myData$wt)
hh <- h + geom_vline(aes(xintercept=weight_mean), color='red', linetype='dashed', size=1)
hh

hhh <- ggplot(myData, aes(x=wt)) +
  geom_histogram(binwidth=0.5, aes(y = ..density..), alpha=0.7, color='black', fill='white') +
  geom_density(alpha=0.2, fill='red')
hhh