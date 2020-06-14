# Title     : TODO
# Objective : TODO
# Created by: mlleg
# Created on: 10.06.2020

library(rvest)
edxsubjects <- read_html('https://www.edx.org/subjects')
subjects_html <- html_nodes(edxsubjects, '.mb-4+ .mb-4 .align-items-center')
subject_text <- html_text(subjects_html)

subject_text