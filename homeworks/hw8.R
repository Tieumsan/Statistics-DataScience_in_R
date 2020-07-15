# Created by: mlleg
# Created on: 15.07.2020

#preparatory work
rm(list=ls())

#quick viz
data <- read.csv('../14.310 - Data Analysis in Social Science/Datasets/nlsw88.csv')
head(data)

# Questions 1-6
#Create linear model
simple <- lm(lwage~yrs_school, data=data)

summary(fit)
coefficients(fit)
#compute a 90% CI for the parameters
ci <- confint(simple, level=0.90)

residuals <- sum(residuals(simple))
residuals

# Questions 7-11
#sample means approach
mean_other <- mean(data$lwage[data$black == 0])
mean_black <- mean(data$lwage[data$black == 1])
mean_other
mean_black-mean_other
#regression approach
simple2 <- lm(lwage~black, data=data)
coefficients(simple2)

summary(simple2)

# Questions 12-17
multiple <- lm(lwage ~ yrs_school + ttl_exp, data=data)
summary(multiple)

multiple_restricted <- lm(lwage ~ I(yrs_school + 2*ttl_exp), data=data)
coefficients(multiple_restricted)

anova_unrestricted <- anova(multiple)
anova_compare <- anova(multiple, multiple_restricted)

test_statistic <- anova_compare$F[2]

p_value <- df(test_statistic, 1, anova_unrestricted$Df[3])
p_value

#Perform the p-value test directly
library(car)
matrixR <- c(0, -2, 1)
linearHypothesis(multiple, matrixR)