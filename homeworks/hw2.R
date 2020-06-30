rm(list = ls())

#rbinom(n, size, prob)
#where n refers to number of observations, size refers to number of trials, 
#and prob refers to probability of success on each trial

successes <- rbinom(1000, 8, 0.2)
#Question 9&10
hist(successes)

#Question 12
#probability of getting exactly 7 heads on 10 flips
#dbinom(x, size, prob) where x is the observations, 
#size is number of trials, prob is probability
#pbinom(q, size, prob) where q is the number of observations,
#size is the number of trials, prob is the probability

# dbinom(x, n, prob) = f(n, p) (returns the value of the PDF at x)
#Part A
f_x <- dbinom(7, 10, 0.65)
f_x
#Part B
# pbinom(x, n, prob) = F(n, p) (returns the value of the CDF at x)
F_x <- pbinom(7, 10, 0.65)
F_x
#Part C
Fi_x <- pbinom(6, 10, 0.65, lower.tail = FALSE)
Fi_x
# qbinom(x, n, prob) = F^-1(n, p) (returns the inverse of the CDF -> the value for which the CDF is equal to x)

#Question 14
binom_draws <- as_tibble(data.frame(successes))
mutate(count(group_by(binom_draws, successes), n=n()), freq=n/(sum(binom_draws)))
estimated_pf <- binom_draws %>%
  group_by(successes) %>%
  summarize(n=n()) %>%
  mutate(freq=n/sum(n))

ggplot(estimated_pf, aes(x=successes, y=freq)) +
  geom_col() +
  ylab("Estimated Density")

#Question 15
#Create a tibble with x and the analytical probability densities.
n <- 1000
p <- 0.2
my_binom<-as_tibble(list(x=0:n, prob=dbinom(0:n, n, p)))

#Plot the computed theoretical density.
ggplot(my_binom, aes(x=x, y=prob)) + geom_col() +
  ylab("Analytical Density")

calculated_cdf <- my_binom %>%
  mutate(cdf=cumsum(prob))

#Plot the computed cdf
ggplot(calculated_cdf, aes(x=x, y=cdf)) + geom_step() + 
  ylab("CDF")