# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 09.06.2020

# 3 - Functions
function_name <- function(x, y) {
  x <- 2 * x
  x + y
}
function_name(3, 4)

multiple_args <- function(..., start='START', stop='STOP') {
  words <- list(...)
  word <- words[]
  paste(start, word, stop)
}

# 4 - lapply and sapply
## lapply and sapply loop through the 1st arg and apply the function in the 2nd arg
# to create a list/vector or matrix with the outputs produced
result <- sapply(c(7, 2, 3, 4, 4, 5, 5, 6, 6), unique)

# 5 vapply and tapply
## vapply is a safer version of sapply
# (we simply add the expected output and get an error if the output does not correspond to expected output)
## tapply allows us to split our data into groups and apply a function to each group
vapply(c(1, 3, 54, 56), mean, numeric(1))
tapply(flags$population, flags$landmass, summary)

# 6 - Simulation
## we can easily simulate random variables with R
## Each probability distribution in R has a density (dnorm()),
# a distribution function (pnorm()), a quantile function (qnorm()) and a random generation function (rnorm())
# sample with/without replacement
sample(1:10, 5, replace = TRUE)
# sample from a probability distribution
rnorm(10, mean = 2, sd = 0.5)

# 7 - Dates and Times
# We can quite easily deal with dates and time in R
time <- Sys.time()
Sys.time() > time
Sys.time() - time
months(time)

time2 <- as.POSIXlt(Sys.time())
str(unclass(time2))
time2$mday

date <- as.Date('1994-16-11')

# 8 - Dates and Ti mes with lubridate
## lubridate allows us to work more conveniently with dates and time

# 11 - Graphics Devices
#available graphics devices (screen, pdf, png, bitmap, ...)
?Devices

table(state)