# Created by: mlleg
# Created on: 28.08.2020

library(tidyverse)
library(modelr)
options(na.action = na.warn)

model1 <- function(coefficients, data) {
  coefficients[1] + data$x * coefficients[2]
}

measure_sq_distance <- function(model, data) {
  difference <- data$y - model1(model, data)
  sqrt(mean(difference^2))
}

sim_distance <- function(a_0, a_1) {
  measure_sq_distance(c(a_0, a_1), sim1)
}
models <- models %>%
  mutate(distance = purrr::map2_dbl(a_0, a_1, sim_distance))

#### Linear Model by Newton-Raphson method ####
best <- optim(c(0, 0), measure_sq_distance, data = sim1)
best$par

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = best$par[1], slope = best$par[2], color = "blue")

#### Linear Model w/ base R ####
sim1_model <- lm(y ~ x, data = sim1)
coef(sim1_model)

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = sim1_model$coefficients[1], slope = sim1_model$coefficients[2], color = "blue")

#1
#We can observe that the model is sensitive to outliers, due to the squared distance used to compute it.
sim1a <- tibble(
x = rep(1:10, each = 3),
y = x * 1.5 + 6 + rt(length(x), df = 2)
)

sim1a_model <- lm(y ~ x, data = sim1a)
ggplot(sim1a, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = sim1a_model$coefficients[1], slope = sim1a_model$coefficients[2], color = "blue") +
  labs(title = "Root-Mean-Squared distance model")

#2
#We can make our linear model more robust by using the mean-absolute distance instead of the root-mean-squared distance
measure_abs_distance <- function(model, data) {
  difference <- data$y - model1(model, data)
  mean(abs(difference))
}
best <- optim(c(0, 0), measure_abs_distance, data = sim1a)
best$par

ggplot(sim1a, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = best$par[1], slope = best$par[2], color = "blue") +
  labs(title = "Mean-Absolute distance model")


#### Predictions and Residuals ####
grid <- sim1 %>%
  data_grid(x)
grid

grid <- grid %>%
  add_predictions(sim1_model) #adds predicted values for each x
grid

sim1 <- sim1 %>%
  add_residuals(sim1_model) #adds the residuals for each pair(x, y)
sim1

##To understand what the residuals have to say, it is a good idea to plot them (frequency or scatterplots)
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth = 0.5)

ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0, size = .5, colour = "red") +
  geom_point()

#1
sim1_model2 <- loess(y ~ x, data = sim1)
grid <- sim1 %>%
  data_grid(x)
grid <- grid %>%
  add_predictions(sim1_model2)
sim1 <- sim1 %>%
  add_residuals(sim1_model2)
sim1_model2$fitted

#Model plot
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y), size = 2, color = "grey30") +
  geom_line(aes(y = pred), data = grid, color = "blue", size = 1) +
  labs(title = "Model using loess() (polynomial regression)")

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y), size = 2, color = "grey30") +
  geom_smooth(aes(y = pred), data = grid, color = "blue", size = 1) +
  labs(title = "Model using geom_smooth()")
#Residual plots
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth = 0.5)
ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0, size = .5, colour = "red") +
  geom_point()

#2
?gather_predictions

#3
## geom_ref_line() adds a reference line to the plot.
# This is especially useful and important to display such a line in a residuals plot
# to have a reference and quickly see if the residuals are skewed towards the positives of negatives.

#### Formulas & Model Families ####
## Continuous variable vs. Categorical variable
ggplot(sim3, aes(x1, y)) +
  geom_point(size = 2, aes(color = x2))
#there are 2 models we can fit to this data:
model1 <- lm(y ~ x1 + x2, data = sim3)
model2 <- lm(y ~ x1 * x2, data = sim3)

grid <- sim3 %>%
  data_grid(x1, x2) %>%
  gather_predictions(model1, model2)
grid

ggplot(sim3, aes(x1, y, color = x2)) +
  geom_point(size = 2) +
  geom_line(data = grid, size = 1, aes(y = pred)) +
  facet_wrap(~ model)

#we analyze the residuals of each model to assess which one is the best
sim3 <- sim3 %>%
  gather_residuals(model1, model2)

ggplot(sim3, aes(x1, resid, color = x2)) +
  geom_point(size = 2) +
  facet_grid(model ~ x2)

model_matrix(sim3, model1)
model_matrix(sim3, model2)

## Interactions (2 continuous variables)
model1 <- lm(y ~ x1 + x2, data = sim4)
model2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>%
  data_grid(
    x1 = seq_range(x1, 5),
    x2 = seq_range(x2, 5)
  ) %>%
  gather_predictions(model1, model2)
grid

#2
model_matrix(sim4, model1)
model_matrix(sim4, model2)

#4
sim4 <- sim4 %>%
  gather_residuals(model1, model2)

ggplot(sim4, aes(resid, color = model)) +
  geom_freqpoly(binwidth = 0.5, size = 1) +
  geom_rug()

ggplot(sim4, aes(abs(resid), color = model)) +
  geom_freqpoly(binwidth = 0.5, size = 1) +
  geom_rug()

#we compare the standard deviation of both models to compare them more rigorously
sim4 %>%
  group_by(model) %>%
  summarize(resid = sd(resid))
#we can now see that the standard deviation of model2 is slighty smaller than that of model1.
# Hence model2 is slightly better.

