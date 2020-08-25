# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 06.06.2020

library(tidyverse)
papers <- as_tibble(read_csv('../14.310 - Data Analysis in Social Science/Datasets/CitesforSara.csv'))
papers

papers_select <- papers %>% select(journal, year, cites, title, au1)
papers_select

summary(filter(papers_select, cites >= 100))

# How many total citations for the journal 'Econometrica' ?
journal_grouped <- group_by(papers_select, journal)
summarize(grouped, sum_cites = sum(cites))

#Distinct primary authors (au1)
n_distinct(papers_select$au1)

# select only the papers that contains 'female'
papers_female <- papers_select %>% select(contains('female'))
papers_female

#### Exam
library(tidyverse)
df <- read_csv('../14.310 - Data Analysis in Social Science/Datasets/qian.csv')
summary(df)
dim(df)

filter(df, biryr >= 1979)

df$post <-  df$biryr >= 1979
df$post[df$post == FALSE] <-  0
df$post[df$post == TRUE] <-  1

post_on <- filter(df, post == 1)
sum(post_on$teasown)
mean <- sum(post_on$teasown) / dim(post_on)[1]
mean

model <- lm(sex ~ teasown + post + I(teasown * post), data = df)
summary(model)

