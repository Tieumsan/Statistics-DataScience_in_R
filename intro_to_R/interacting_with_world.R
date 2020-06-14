# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 14.06.2020
library(tidyverse)

# 1.Import data
data_csv <- read.csv('../14.310 - Data Analysis in Social Science/Datasets/Bihar_sample_data.csv', header = TRUE)

data_txt <- read.table('', sep = ',', header = TRUE)

# 2.Assess Data
is.data.frame(data_csv)

filtered <- filter(data_csv, adult==1)
sort(unique(filtered$age)) #sorted set of unique values in dataset
max(filtered$age) #max value in dataset
min(filtered$age) #min value in dataset

which(filtered$age == 25) #indexes of rows where age=25
length(which(filtered$age == 25)) #nb of people who has age=25

# 3.Manipulate Data
is.matrix(data_csv)
data_matrix <- as.matrix(data_csv)
is.matrix(data_matrix)
head(data_matrix)

matrix <- matrix(1, 2, 3)
transposed_matrix <- t(matrix)

#when adding rows/columns, take care to the correct number to add
matrix <- rbind(matrix, c(2, 3, 5)) #add a row to matrix
matrix <- cbind(matrix, c(8, 13, 21)) #add a column to matrix

refined <- matrix[, 4]
refined