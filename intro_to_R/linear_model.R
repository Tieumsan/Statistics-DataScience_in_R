# Created by: mlleg
# Created on: 14.07.2020

?lm

#dataset
height <- c(176, 154, 138, 196, 132, 176, 181, 169, 159, 180, 120)
weight <- c(82, 49, 53, 112, 47, 69, 77, 71, 62, 74, 45)

#create a linear model
fit <- lm(weight~height) # Y~X

class(fit)
summary(fit)
names(fit)

#plot the linear model
plot(height, weight) #X, Y
abline(fit, col='red')