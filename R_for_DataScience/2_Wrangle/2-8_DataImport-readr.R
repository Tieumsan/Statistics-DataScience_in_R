# Created by: mlleg
# Created on: 11.08.2020

#1
read_delim("a|b|c|d", delim = '|')
str <- toString("x,y\n1,'a,b'")
read_delim(str, delim = ',', , quote = '\'')

#### Date, Date-Time, Time ####
#generate the correct format string
d1 <- 'January 1, 2010'
parse_date(d1, format = '%B %d, %Y')
d2 <- '2015-Mar-07'
parse_date(d2, format = '%Y-%b-%d')
d3 <- '06-Jun-2017'
parse_date(d3, '%d-%b-%Y')
d4 <- c('August 19 (2015)', 'July 1 (2015)')
parse_date(d4, '%B %d (%Y)')
d5 <- '12/30/14' #Dec 30, 2014
parse_date(d5, '%m/%d/%y')
t1 <- '1705'
parse_time(t1, '%H%M')
t2 <- '11:15:10.12 PM'
parse_time(t2)

#### Problems ####
challenge <- read_csv(readr_example('challenge.csv'))
problems(challenge)
## A good strategy is to work column by column unto there are no problems remaining
challenge <- read_csv(
  readr_example('challenge.csv'),
  col_types = cols(
    x = col_double(), #we first got col_integer before getting to col_double
    y = col_date()
  )
)
tail(challenge)