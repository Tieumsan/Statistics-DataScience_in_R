# Created by: mlleg
# Created on: 31.07.2020

#data to be tested against N(0,1)
n <- 1000
gaussian_rv <- rnorm(n)
cauchy_rv <- rcauchy(n)
exp_rv <- rexp(n, 2.5) + 13
unif_rv <- runif(n, min=-sqrt(3), max=sqrt(3))

#test data
qqnorm(cauchy_rv)
qqline(cauchy_rv, col='red', lwd=2)