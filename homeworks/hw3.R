# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 14.06.2020

## 1.Preliminary work
rm(list = ls()) #removes all current existing objects in R
library('utils')
library('tidyverse')

## 2.Getting the data
gender_data <- as_tibble(read.csv('../14.310 - Data Analysis in Social Science/Datasets/Gender_StatsData.csv'))

## 3.Exploring the dataset
head(gender_data) #6 first observations (respectively tails(.) -> 6 last obs)
names(gender_data) #list of variable names
dim(gender_data) #nb of observations and variables
str(gender_data)

## 4.Targetting data of interest
teenager_fr <- filter(gender_data, Indicator.Code == 'SP.ADO.TFRT') #basic-R equivalent: subset(data, condition)
teenager_fr
#Now that we have our data of interest, we can free some memory space in R
# by removing the whole dataset from our environment
rm(gender_data)

## 5.Exploring the data of interest
summary(teenager_fr) #min, median, mean, max, nas for every variables of the dataset
min(teenager_fr$X1960, na.rm = TRUE)
max(teenager_fr$X1960, na.rm = TRUE)
round(mean(teenager_fr$X2000, na.rm = TRUE), 2)
round(sd(teenager_fr$X2000, na.rm = TRUE), 2)

sort(unique(teenager_fr$Country.Code))
#filter the data by income levels and world average
by_incomeLevel <- filter(teenager_fr, Country.Code %in% c('LIC', 'MIC', 'HIC', 'WLD'))
head(by_incomeLevel)

#getting rid of the variables which are not useful anymore
# and organize the dataset in a more intuitive way
#move the column names 'X1960:X2015' into a new variable 'Year' and stores the variable values into a new variable 'FertilityRate'
plotData_byGroupYear <- gather(by_incomeLevel, 'Year', 'FertilityRate', X1960:X2015) %>%
  select(Year, Country.Name, Country.Code, FertilityRate)
head(plotData_byGroupYear)
# => Recommended maintained equivalent version to gather(...):
plotData_newByGroupYear <- pivot_longer(by_incomeLevel, X1960:X2015, names_to = 'Year', values_to = 'FertilityRate') %>%
  select(Year, Country.Name, Country.Code, FertilityRate)
head(plotData_newByGroupYear)

#reorganize the data by year and have the fertility rates for each income group as separate variable
plotData_byYear <- select(plotData_byGroupYear, Country.Code, Year, FertilityRate) %>%
  spread(Country.Code, FertilityRate)
head(plotData_byYear)
# => Recommended maintained equivalent version to spread(...):
plotData_newByYear <- select(plotData_byGroupYear, Country.Code, Year, FertilityRate) %>%
  pivot_wider(names_from = Country.Code, values_from = FertilityRate)
head(plotData_newByYear)

# 6. Start plotting the data
ggplot(plotData_byGroupYear, aes(x=Year, y=FertilityRate, group=Country.Code, color=Country.Code)) +
  geom_line() +
  labs(title = 'Fertility Rate by Country-Income-Level over Time')

#we could improve our graph by removing the leading 'X' in the x-axis and changing these variables type to numeric
plotData_byGroupYear <- mutate(plotData_byGroupYear, Year=as.numeric(str_replace(Year, 'X', '')))
#alternatives: str_sub(Year, -4) OR str_sub(Year, start=2, end=5)


### We will now consider the distribution of the fertility rate between 1960 and 2000
histData_twoYears <- select(teenager_fr, Country.Name, Country.Code, Indicator.Name, Indicator.Code, X1960, X2000)

histData_twoYears <- pivot_longer(teenager_fr, c(X1960, X2000), names_to = 'Year', values_to = 'FertilityRate') %>%
  select(Year, Country.Code, Country.Name, FertilityRate)

histData_twoYears <- filter(histData_twoYears, !is.na(FertilityRate))

?geom_histogram
ggplot(histData_twoYears, aes(x=FertilityRate)) +
  geom_histogram(data = filter(histData_twoYears, Year=='X1960'), color = 'darkred', fill = 'red', alpha = 0.2) +
  geom_histogram(data = filter(histData_twoYears, Year=='X2000'), color = 'darkblue', fill = 'blue', alpha = 0.2)

ggsave('graphs/hist.png')

#now we'll add some kernel density to the histogram
ggplot(histData_twoYears, aes(x=FertilityRate, group=Year, color=Year, alpha=0.2)) +
  geom_histogram(aes(y=..density..)) +
    geom_density(data = filter(histData_twoYears, Year=='X1960'), color = 'darkred', fill = 'red', alpha = 0.2, bw = 5) +
    geom_density(data = filter(histData_twoYears, Year=='X2000'), color = 'darkblue', fill = 'blue', alpha = 0.2, bw = 5)


## Plot a Joint PDF
library('utils')
library('plot3D')

#Create the vectors x and y
M <- mesh(seq(0, 1, length = 100), seq(0, 1, length = 100))
x <- M$x
y <- M$y
z <- 6/5 * (x + y^2)

#Plot the PDF
persp3D(x, y, z, xlab = 'X variable', ylab = 'Y variable', xlim = c(0,1), main = 'Plot of joint PDF')

#marginal PDF's
x <- seq(0, 1, length = 1000)
y <- seq(0, 1, length = 1000)
cdf_x <- x/5 * (3*x + 2)
cdf_y <- x/5 * (2*x^2 + 3)
#Plot the CDF's
plot(x, cdf_x, type='l', col='blue', xlab='x', ylab='Cumulative Distribution', xlim=c(0, 1), main='CDF plot')
lines(y, cdf_y, lty=2, col='red', lwd=2)
legend('bottomright', ncol=1, legend=c('X', 'Y'), lty=c(1, 2), col=c('blue', 'red'))