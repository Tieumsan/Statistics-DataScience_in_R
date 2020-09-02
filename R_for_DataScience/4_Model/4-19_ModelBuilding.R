# Created by: mlleg
# Created on: 01.09.2020

library(tidyverse)
library(modelr)
library(hexbin)

library(nycflights13)
library(lubridate)

#### Diamonds ####

#we recall that our boxplots for the price of diamonds did not conveyed much useful information,
# as carat what overwhelmingly significant in the price of diamonds
ggplot(diamonds, aes(cut, price)) + geom_boxplot()
ggplot(diamonds, aes(color, price)) + geom_boxplot()
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()

#relationship between price and carat
ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins = 50)
#we can render the relationship linear by logging the price and carat
diamonds2 <- diamonds %>%
  filter(carat <= 2.5) %>%
  mutate(
    lprice = log(price),
    lcarat = log(carat)
  )

ggplot(diamonds2, aes(lcarat, lprice)) +
  geom_hex(bins = 50)

#now that we clearly see the pattern, we make it explicit and remove it from the data
model_diamond <- lm(lprice ~ lcarat, data = diamonds2)
mod_log <- lm(log2(price) ~ log2(carat), data = diamonds)
mod_log
#and we look at the residuals
diamonds2 <- diamonds2 %>%
  add_residuals(model_diamond, "lresid")
ggplot(diamonds2, aes(lcarat, lresid)) +
  geom_hex(bins = 50)
#the plot of residuals looks pretty normally distributed, indicating that we correctly uncovered the main pattern
#we now replot our initial boxplot, w/ the pattern removed from the data
ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(color, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot()
#BEWARE OF THE INTERPRETATION OF THE NEW SCALE!
# A residual of -1 indicates that 'lprice' was 2^(-1) lower than predicted solely on its carat (as we used log2(price), log2(carat)).

#1

#2
# The model log(price) = a_0 + a_1 * log(carat) indicates
# that the log(price) of diamonds is linearly explained by log(carat)

#### Flights ####
# Let's investigate the nb of flights per day to see what kind of patterns we could uncover
daily <- flights %>%
  mutate(date = make_date(year, month, day)) %>%
  group_by(date) %>%
  summarize(n = n())
daily

ggplot(daily, aes(date, n)) +
  geom_line()
#We can observe a regular strong pattern
#We can verify that there is a strong day-of-week pattern that dominates maybe subtler pattern
daily <- daily %>%
  mutate(wday = wday(date, label = TRUE))
ggplot(daily, aes(wday, n)) +
  geom_boxplot()
#We can see there are fwer flights on weekends. A first hypothesis would be because most people fly for business
# One way to remove the strong pattern is to render it explicit through a model
model_flights <- lm(n ~ wday, data = daily)

grid <- daily %>%
  data_grid(wday) %>%
  add_predictions(model_flights, "n")

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, color = "red", size = 4)

#We then compute and visualize the residuals to try to uncover other patterns that were hidden by the strong weekend effect
daily <- daily %>%
  add_residuals(model_flights)
daily %>%
  ggplot(aes(date, resid)) +
  geom_ref_line(h = 0, colour = "red", size = 0.5) +
  geom_line()
#we start seeing strong failures from approximately june. We draw one line for each weekday to observe other regular patterns
ggplot(daily, aes(date, resid, color = wday)) +
  geom_ref_line(h = 0, colour = "red", size = 0.5) +
  geom_line()

#We clearly see a regular failure of our model for Saturdays during summer and fall.
# We'll therefore focus our attention to Saturdays
daily %>%
  filter(wday == "sam") %>%
  ggplot(aes(date, n)) +
  geom_point() +
  geom_line() +
  scale_x_date(
    NULL,
    date_breaks = "1 month",
    date_labels = "%b"
  )

#We can suppose that these pattern is linked to the school terms.
# We create a new variable that captures those terms is distinguish between these periods
term <- function(date) {
  cut(date,
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("Spring", "Summer", "Fall")
  )
}

daily <- daily %>%
  mutate(term = term(date))
daily

daily %>% filter(wday == "sam") %>%
  ggplot(aes(date, n, color = term)) +
  geom_point(alpha = 1/3) +
  geom_line() +
  scale_x_date(
    NULL,
    date_breaks = "1 month",
    date_labels = "%b"
  )

#as it looks like there is a significant variation across the different terms,
# it might be a good idea to fit a day-of-week effect for each term
model_without_term <- lm(n ~ wday, data = daily)
model_with_term <- lm(n ~ wday * term, data = daily)

daily %>%
  gather_residuals(without_term = model_without_term, with_term = model_with_term) %>%
  ggplot(aes(date, resid, color = model)) +
  geom_line(alpha = 0.75)

#By overlaying the predictions of our model onto the raw data,
# we can see that the model succeeds in finding the mean effect, but we still have a lot of big outliers.
# Therefore we'll model using absolute value to diminish the impact of those outliers
model_absolute <- MASS::rlm(n ~ wday * term, data = daily)
daily %>%
  add_residuals(model_absolute, "resid") %>%
  ggplot(aes(date, resid)) +
  geom_hline(yintercept = 0, size = 1, color = "red") +
  geom_line()

#It is good practice to bundle the creation of variables up into a function. Especially when working w/ many models
compute_vars <- function(data) {
  data %>%
    mutate(
    term = term(date),
    wday = wday(date, label = TRUE)
    )
}