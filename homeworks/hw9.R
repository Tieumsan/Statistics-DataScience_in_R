# Created by: mlleg
# Created on: 17.07.2020

#Preparatory work
rm(list=ls())

#Questions 1-10
#Import & Viz
data <- read.csv('../14.310 - Data Analysis in Social Science/Datasets/fastfood.csv')
head(data)

#NJ prior
wage_NJ_prior <- data$wage_st[data$state == 1]
empft_NJ_prior <- data$empft[data$state == 1]
NJ_prior <- data.frame(wage_NJ_prior, empft_NJ_prior)
head(NJ_prior)
#NJ post
wage_NJ_post <- data$wage_st2[data$state == 1]
empft_NJ_post <- data$empft2[data$state == 1]
NJ_post <- data.frame(wage_NJ_post, empft_NJ_post)
head(NJ_post)

#PA prior
wage_PA_prior <- data$wage_st[data$state == 0]
empft_PA_prior <- data$empft[data$state == 0]
PA_prior <- data.frame(wage_PA_prior, empft_PA_prior)
head(PA_prior)
#PA post
wage_PA_post <- data$wage_st2[data$state == 0]
empft_PA_post <- data$empft2[data$state == 0]
PA_post <- data.frame(wage_PA_post, empft_PA_post)
head(PA_post)

mean_PA_empft_prior <- mean(empft_PA_prior)
mean_NJ_empft_prior <- mean(empft_NJ_prior)
mean_NJ_empft_prior-mean_PA_empft_prior

# ------------- OTHER WAY -------------
simple1 <- lm(empft ~ state, data = data)
simple2 <- lm(emppt ~ state, data = data)
simple3 <- lm(wage_st ~ state, data = data)

summary(simple1)
summary(simple2)
summary(simple3)
#Linear Models
simple_empft <- lm(empft_PA_prior ~ empft_NJ_prior)

multi <- lm(I(empft2 - empft) ~ state, data=data)
summary(multi)

# Questions 11-18
data <- read.csv('../14.310 - Data Analysis in Social Science/Datasets/indiv_final.csv')
head(data)

#Question 11
same_party <- c(data$difshare > 0)
head(same_party)
sum(same_party)/length(same_party)

library(rdd)
dc_density <- DCdensity(data$difshare, ext.out=TRUE)
dc_density$theta
dc_density$p

#same_party_50 <- c(abs(data$difshare) <=0.5)

model1 <- lm(myoutcomenext ~ same_party, data = data, subset = abs(difshare) <= 0.5)
model2 <- lm(myoutcomenext ~ same_party + difshare, data=data, subset = abs(difshare) <= 0.5)
model3 <- lm(myoutcomenext ~ same_party + difshare + I(difshare * same_party), data=data, subset = abs(difshare) <= 0.5)
model4 <- lm(myoutcomenext ~ same_party + difshare + difshare^2, data=data, subset = abs(difshare) <= 0.5)
model5 <- lm(myoutcomenext ~ same_party + difshare + difshare^2 + I(difshare * same_party) + I(difshare^2 * same_party), data=data, subset = abs(difshare) <= 0.5)
model6 <- lm(myoutcomenext ~ same_party + difshare + difshare^2 + difshare^3, data=data, subset = abs(difshare) <= 0.5)
model7 <- lm(myoutcomenext ~ same_party + difshare + difshare^2 + difshare^3 + I(difshare * same_party) + I(difshare^2 * same_party) + I(difshare^3 * same_party), data=data, subset = abs(difshare) <= 0.5)


model1$coefficients[2]

matrix_coef <- matrix(NA, nrow = 2, ncol = 7)

matrix_coef[1, 1] <- model1$coefficients[2]
pvalue <- summary(model1)
matrix_coef[2, 1] <- pvalue$coefficients[2, 4]

matrix_coef[1, 2] <- model2$coefficients[2]
pvalue <- summary(model2)
matrix_coef[2, 2] <- pvalue$coefficients[2, 4]

matrix_coef[1, 3] <- model3$coefficients[2]
pvalue <- summary(model3)
matrix_coef[2, 3] <- pvalue$coefficients[2, 4]

matrix_coef[1, 4] <- model4$coefficients[2]
pvalue <- summary(model4)
matrix_coef[2, 4] <- pvalue$coefficients[2, 4]

matrix_coef[1, 5] <- model5$coefficients[2]
pvalue <- summary(model5)
matrix_coef[2, 5] <- pvalue$coefficients[2, 4]

matrix_coef[1, 6] <- model6$coefficients[2]
pvalue <- summary(model6)
matrix_coef[2, 6] <- pvalue$coefficients[2, 4]

matrix_coef[1, 7] <- model7$coefficients[2]
pvalue <- summary(model7)
matrix_coef[2, 7] <- pvalue$coefficients[2, 4]

matrix_coef

rd_estimate <- RDestimate(myoutcomenext ~ difshare, data=data, subset=abs(data$difshare) <=0.5)
rd_estimate$est
plot(rd_estimate)

rd_estimate2 <- RDestimate(myoutcomenext ~ difshare, data=data, subset=abs(data$difshare) <=0.5, bw=3*rd_estimate$bw[1])
plot(rd_estimate2)

rd_estimate3 <- RDestimate(myoutcomenext ~ difshare, data=data, subset=abs(data$difshare) <=0.5, bw=rd_estimate$bw[1]/3)
plot(rd_estimate3)