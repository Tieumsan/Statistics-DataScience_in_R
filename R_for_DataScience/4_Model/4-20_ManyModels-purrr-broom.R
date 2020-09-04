# Created by: mlleg
# Created on: 03.09.2020

library(modelr)
library(tidyverse)

library(gapminder)
#### gapminder ####
#When we have to work w/ a lot of models, we might need some other tools to facilitate their creation/storage
#We'll explore that by analyzing the trend of life expectancy of different countries across the years
gapminder
gapminder %>%
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)
#While we clearly see a trend, we would like to fit a model to each the countries.
# We know how to do it individually, but doing it individually for all countries would be a pain.

### Reminder for individually fitting a model:
fr <- filter(gapminder, country == "France")
fr %>%
  ggplot(aes(year, lifeExp)) +
  geom_line() +
  ggtitle("Full data")

fr_model <- lm(lifeExp ~ year, data = fr)
fr %>%
  add_predictions(fr_model) %>%
  ggplot(aes(year, pred)) +
  geom_line() +
  ggtitle("Linear trend")

fr %>%
  add_residuals(fr_model) %>%
  ggplot(aes(year, resid)) +
  geom_hline(yintercept = 0, color = "red", size = 1) +
  geom_line() +
  ggtitle("Remaining pattern")

#Instead of manually fitting models individually, we can nest a dataframe into another dataframe w/ purrr
by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()
by_country
#we can see each what each list-column contains for each country
by_country$data[[1]]

#Now that we have our nested dataframe, we can create a function to fit a model for each country and apply it to all df
model_country <- function(df) {
  lm(lifeExp ~ year, data = df)
}

models <- map(by_country$data, model_country) #an even better option would be to directly add a new variable to the df

by_country <- by_country %>%
  mutate(
    model = map(data, model_country),
    resids = map2(data, model, add_residuals)
  )
by_country

#Now, how can we plot the residuals (i.e. a list of dataframes) ?
#As we can nest dataframes, we can unnest them
resids <- unnest(by_country, resids)
resids
by_country

#and we plot the residuals for each country
resids %>%
  ggplot(aes(year, resid)) +
  geom_line(aes(group = country), alpha = 1/3) +
  geom_smooth(se = FALSE)
#which we can facet by continent to get a clearer view
resids %>%
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 1/3) +
  facet_wrap(~continent)

#we now want to have a glance at the overall model quality for each model we fitted to the countries
glance <- by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  select(-c(data, model, resids)) %>%
  unnest(glance)
glance
#we can now easily look at models that don't fit well, and particularly to the bad ones
glance %>%
  arrange(r.squared)
glance %>%
  ggplot(aes(continent, r.squared)) +
  geom_jitter(width = 0.5)

bad_fit <- filter(glance, r.squared < 0.25)
gapminder %>%
  semi_join(bad_fit, by = "country") %>%
  ggplot(aes(year, lifeExp, color = country)) +
  geom_line()

##A general effective list-column pipeline is:
# 1. Create the list-column w/ nest(), summarize() + list(), or mutate() + map()
# 2. Create other intermediate list-columns by transforming existing list-columns w/ map()
# 3. Simplify the list-column back down to a data frame/atomic vector
## We should make sure that list-columns are homogeneous!