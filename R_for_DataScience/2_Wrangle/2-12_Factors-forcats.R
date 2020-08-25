# Created by: mlleg
# Created on: 24.08.2020

## factors are categorical variables that have a fixed and knwon set of possible values
library(tidyverse)
library(forcats)

#### Intro + Creating Factors ####
#2
survey <- forcats::gss_cat
head(survey)

survey %>%
  count(relig, sort = TRUE)

#### Modifying Factor Order ####
relig <- survey %>%
  group_by(relig) %>%
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

survey %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

#### Modifying Factor Levels ####
survey %>% count(partyid)

survey %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat",
                              "Other" = "No answer",
                              "Other" = "Don't know",
                              "Other" = "Other party")) %>%
  count(partyid)

survey %>%
  mutate(partyid = fct_collapse(partyid,
         other = c("No answer", "Don't know", "Other party"),
         republican = c("Strong republican", "Not str republican"),
         independent = c("Ind,near rep", "Independent", "Ind,near dem"),
         democrat = c("Not str democrat", "Strong democrat"))) %>%
  count(partyid)

survey %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = 10)