# Title     : Intro du R
# Objective : Learn the basics of R language
# Created by: mlleg
# Created on: 04.06.2020

x <- 5 + 7

z <- c(1, 2, 3, 4)
z * 2 + 5

v <- seq(1, 20, length=30)
w <- seq(1, 20, by=0.5)

a <- rep(c(0, 1, 2), times=5)
b <- rep(c(0, 1, 2), each=3)

tf <- z%%2 == 0
paste(z, c("X", "Y", "Z", "W"), sep = "")

vect_names <- c('foo', 'bar', 'norf', 'foobar')
names(z) <- vect_names
z[-c(2, 4)] ## select all except indexes 2, 4

my_vector <- c(1:20)
dim(my_vector) <- c(4, 5)

my_matrix <- matrix(1:20, nrow = 4, ncol = 5)
identical(my_vector, my_matrix)

bros <- c('Mat', 'Il', 'Al', 'In')
my_data <- data.frame(cnames, my_data)
cnames <- c('bro', 'age', 'weight', 'bp', 'rating', 'test')
colnames(my_data) <- cnames
my_data

res <- students2 %>% gather(sex_class, count, -grade) %>% separate(sex_class, c('sex', 'class'))