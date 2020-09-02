# Created by: mlleg
# Created on: 24.08.2020

library(tidyverse)
library(lubridate)
library(nycflights13)

#### Creating Date/Times ####
## There's 3 ways to create date/times:
## 1: from strings, 2: From individual components (year, month, day, ... present in tables), 3: From other types (switch between date/time/datetime)
#1
ymd(c("2010-10-10", "bananas"))
#2
today(tz = "CEST")
now(tz = "")
#3
d1 <- "January 1, 2010"
mdy(d1)
d2 <- "2015-Mar-07"
parse_date_time(d2, "Y-b-d")
d3 <- "06-Jun-2017"
parse_date_time(d3, "d-b-Y")
d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)
d5 <- "12/30/14"
mdy(d5)

now(tz = "Europe/Moscow")

?dplyr::near