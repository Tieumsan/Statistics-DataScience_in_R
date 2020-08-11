# Created by: mlleg
# Created on: 19.07.2020

#Preparatory work
rm(list=ls())

# Data Viz
data <- read.csv('../14.310 - Data Analysis in Social Science/Datasets/census80.csv')
summary(data)

# Questions 1-9
## indicator variable
multiple_pregnancy <- na.exclude(c(data$ageq2nd == data$ageq3rd))
prop_multi_preg <- sum(multiple_pregnancy) / length(data$ageq2nd)
prop_multi_preg
# other way
data$temp[data$ageq2nd == data$ageq3rd] <- 1
data$multiple <- 0
data$multiple[data$temp == 1] <- 1
summary(data$multiple)

same_sex <- na.exclude(c(data$sex1st == data$sex2nd))
prop_same_sex <- sum(same_sex) / length(data$sex1st)
prop_same_sex
# other way
data$samesextemp <- (data$sex1st == data$sex2nd)
data$samesex[data$samesextemp == FALSE] <- 0
data$samesex[data$samesextemp == TRUE] <- 1
summary(data$samesex)

data$three <- (data$numberkids == 3)
ols <- lm(workedm ~ three + blackm + hispm +  othracem, data=data)
ols2 <- lm(weeksm ~ three + blackm + hispm +  othracem, data=data)
summary(ols)
summary(ols2)

OLS <- matrix(NA, nrow=2, ncol=2)
OLS[1, 1] <- ols$coefficients[2]
p_value <- summary(ols)
OLS[2, 1] <- p_value$coefficients[2, 4]
OLS[1, 2] <- ols2$coefficients[2]
p_value <- summary(ols2)
OLS[2, 2] <- p_value$coefficients[2, 4]
OLS

first_stage <- lm(three ~ multiple + blackm + hispm +  othracem, data=data)
first_stage$coefficients[2]

second_stage <- lm(three ~ samesex + blackm + hispm +  othracem, data=data)
second_stage$coefficients[2]

iv_model <- ivreg(workedm ~ three + blackm + hispm +  othracem | blackm + hispm +  othracem + multiple, data=data)
iv_model$coefficients[2]

iv_model2 <- ivreg(workedm ~ three + blackm + hispm +  othracem | blackm + hispm +  othracem + samesex, data=data)
iv_model2$coefficients[2]