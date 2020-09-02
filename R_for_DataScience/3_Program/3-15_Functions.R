# Created by: mlleg
# Created on: 27.08.2020

proportion <- function (x) {
  x / sum(x, na.rm = TRUE)
}