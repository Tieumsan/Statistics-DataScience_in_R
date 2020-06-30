# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 22.06.2020

# Sample function
#create the sample set
choices <- c('Moscow', 'London', 'Geneva')
#sample w/ replacement
sample(choices, size=10, replace=TRUE)
#sample w/o replacement
sample(choices, size=2, replace=FALSE)
#sample from a normal distribution
rnorm(n=100)
plot(density(rnorm(n=100000)))

# For loops
#coin tossing
coin <- c('Heads', 'Tails') #create the experiment object
toss <- c() #create empty vector to store results
#simulate experiment
for (i in 1:100){
  toss[i] <- sample(x=coin, size=1)
}
table(toss)

#generate random data
marital <- c('married', 'single') #unviserse for marital status
income <- 1:4
results <- matrix(nrow=100, ncol=3, data=NA) #init results matrix w/ 100x3 NA
colnames(results) <- c('marital', 'income', 'country') #define the names of the variables
head(results)

for (i in 1:100){
  results[i, 1] <- sample(x=marital, size=1)
  results[i, 2] <- sample(x=income, size=1)
  results[i, 3] <- sample(x=choices, size=1)
}
head(results)

# Apply function
#apply a function to each column
apply(X=results, MARGIN=2, FUN=table)