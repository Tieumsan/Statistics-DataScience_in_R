# Title     : Intro du R
# Objective : Learn the basics of R language
# Created by: mlleg
# Created on: 04.06.2020

x <- 5 + 7

z <- c(1, 2, 3, 4)
z * 2 + 5

v <- seq(1, 20, length=30)
w <- seq(1, 20, by=0.5)

a <- rep(c(0, 1, 2), times=5)
b <- rep(c(0, 1, 2), each=3)

tf <- z%%2 == 0
paste(z, c("X", "Y", "Z", "W"), sep = "")