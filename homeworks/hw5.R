# Created by: mlleg
# Created on: 23.06.2020

# ____Q1-2____
shipment <- 100 #total nb of parts
defective_threshold <- 6 #threshold above which the shipment is unacceptable
acceptable_threshold <- 0 #nb of defective parts inspected where the sample leads to accept the shipment
k <- 32 #nb of parts inspected
#Probability that the manufacturer accepts an unacceptable shipment
rv <- dhyper(acceptable_threshold, defective_threshold, shipment-defective_threshold, k)
rv

acceptable_threshold <- 1
threshold_probability <- 0.1
k <- 32
rv <- phyper(acceptable_threshold, defective_threshold, shipment - defective_threshold, k)
while (rv > threshold_probability) {
  k <- k+1
  rv <- phyper(acceptable_threshold, defective_threshold, shipment - defective_threshold, k)
}
# ____Q4____
# X: #of chocolate chips on a certain type of cookie
# X~Poiss(lambda)
#For which lambda does P(X>=2)=0.99 ?
x <- ppois(1, lambda=c(6, 7, 8, 9), lower.tail=FALSE) #P(X>=2)
x
# ___Q8-13___
#Preliminary work
rm(list=ls())

real_theta <- 5
sample_size <- 100
nb_simulations <- 100000

simulation1 <- matrix(runif(sample_size * nb_simulations, max=real_theta), nrow=nb_simulations)
estimator_mean <- 2 * apply(simulation1, 1, mean)
estimator_median <- 2 * apply(simulation1, 1, median)
head(simulation1, 1)
head(estimator_mean, 10)

plot_mean <- hist(estimator_mean, breaks=100)
plot_median <- hist(estimator_median, breaks=100)

range <- range(plot_mean$mids, plot_median$mids)
plot_mean$counts <- plot_mean$density
plot_median$counts <- plot_median$density

plot(plot_mean, col=rgb(1, 0, 0,1/4), xlim=range, xlab='Values', ylab='Density')
plot(plot_median, col=rgb(0,0,1,1/4), add=TRUE)

var(estimator_mean)