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

# 15 - Working with colors
# color.scale
# show transition palette
showMe <- function(cv) {
  myarg <- deparse(substitute(cv))
  z <- outer(1:20, 1:20, '+')
  obj <- list(x=1:20, y=1:20, z=z)
  image(obj, col=cv, main=myarg)
}
#list the names of 657 predefined colors usable in any plotting function
colors()

##however, we can use palettes to form new colors
#colorRamp takes a palette of colors (args) and returns a function that takes values in [0, 1]
pal <- colorRamp(c('red', 'blue')) #creates colors from red -> blue
pal(0)
pal(seq(0, 1, len=6))

#colorRampPalette also takes a palette of colors and returns a function.
# This function takes ints and returns a vector of colors each of which is a blend of colors of the original palette
# The argument specifies the nb of colors we want returned
rpal <- colorRampPalette(c('red', 'blue'))
alpal <- colorRampPalette(c('blue', 'darkred'), alpha=.5)
rpal(3)

#display the interpolated color palette
showMe(rpal(10))

#RColorBrewer is a package that contains useful color palettes of 3 types (sequential, divergent, qualitative)
# to be chosen from, depending on our data.
# the colorBrewer palettes can be used in conjunction with the colorRamp()/colorRampPalette() functions.
# We would use colors from a colorBrewer palette as our base palette (as args to colorRampPalette)
cols <- brewer.pal(9, 'BuGn') #how many different colors we want, name of the color palette
brewerPal <- colorRampPalette(cols)
showMe(brewerPal(9)) #n in brewer.pal and n in brewerPal have both different effects

plot(x, y, pch=19, col=rpal(20))

## 16 - GGplot 1
#qplot allows us to quickly plot (hence, qplot) different kinds of plots
str(mpg)

# Scatterplot
qplot(displ, hwy, data=mpg, color=drv, geom=c('point', 'smooth')) #x-variable, y-variable, dataset, aesthetic (here color by drv arg), geometric objects
qplot(y=hwy, data=mpg, color=drv) #plot the hwy-value in the order they occur in the dataset and color them by drv arg
qplot(displ, hwy, data=mpg, facets=.~drv) #x-var, y-var, dataset, nb of rows and columns
#in the expression facets=.~drv, left to the ~ =nb of rows (.=1) and to the right=nb of columns (drv has 3 different values => 3cols)

#Boxplot/Whiskerplot
qplot(drv, hwy, data=mpg, geom='boxplot') #variable by which to split the data, variable to examine, dataset, geometric object
qplot(drv, hwy, data=mpg, geom='boxplot', color=manufacturer)#plot the boxplot grouped by drv and divided by manufacturer args

#Histograms
qplot(hwy, data=mpg, fill=drv) #variable for the frequency count, dataset, color by drv variable
qplot(hwy, data=mpt, facets=drv~., binwidth=2) #var for frequency count, dataset, 1 hist for each distinct drv value

## 17 - GGplot 2
#The other workhorse function of ggplot allows us to customise our plots more deeply
# ggplot2 works by layers. This means that we build our plot layer by layer with 'plot + layer +...'
#we assign the ggplot function with our data set and the variables to be plotted to make plotting easier
g <- ggplot(data=mpg, aes(displ, hwy))#we enclosed the args to be represented in the aes (aesthetics)
summary(g) #check the properties of the plot

g + geom_point(size=2, alpha=.5, aes(color=drv)) + geom_smooth(method='lm', size=1, linetype=3, se=FALSE) + facet_grid(.~drv)+
  labs(x='Displacement', y='Highway Mileage', title='Surprise Motherfucker!')
# as we want the color to depend on the data, we need to define the color parameter in the aesthetics

# We could also factor the data by manufacturing year
g <- ggplot(data=mpg, aes(x=displ, y=hwy, color=factor(year)))
g + geom_point() + facet_grid(drv~cyl, margins=TRUE)

#Play with the coordinate limits
g <- ggplot(data=testdat, aes(x=myx, y=myy))
g + geom_line() + coord_cartesian(ylim=c(-3,3))

## 18 - GGPlot2 Extras
