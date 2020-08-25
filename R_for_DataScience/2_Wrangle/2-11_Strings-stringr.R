# Created by: mlleg
# Created on: 21.08.2020

library(tidyverse)
library(stringr)

#### String Basics ####
#1
?paste0 #equivalent to str_c(collapse="")
?str_c
#2
#for str_c(), the sep argument indicates the character used to separate the different elements of the vector with the argument
# while the collapse argument is used to merge all elements of the vector into a length-1 vector

#3
str <- "surprise"
str %>%
  str_sub(str_length(str)/2, str_length(str)/2)

#4
?str_wrap #can be used to format text automatically
str_wrap(str, width = 2, indent = 2)

#### Mathcing Patterns w/ Regular Expressions ####
#2
str_w <- stringr::words
str_view(str_w, "^y", match = TRUE) #start w/ y
str_view(str_w, "x$", match = TRUE) #end w/ x
str_view(str_w, "^...$", match = TRUE) #exactly 3 letters long
str_view(str_w, ".......", match = TRUE) #have 7 letters or more

#1-2
str_view(str_w, '^[aeiouy]', match = TRUE) #start only w/ a vowel
str_subset(str_w, '[aeiouy]', negate = TRUE) #contain only consonants
str_view(str_w, '[^e]ed$', match = TRUE) #end w/ 'ed' but not 'eed'
str_view(str_w, 'i(ng|se|ze)$', match = TRUE) #end w/ 'ing' or 'ize'
str_view(str_w, 'q[^u]', match = TRUE) #is 'q' always followed by a 'u' ?
str_view(str_w, '07\\d \\d\\d\\d \\d\\d \\d\\d', match = TRUE) #match locale telephone number

#3-3
str_view(str_w, '^[^aeiouy]{3}', match = TRUE) #start w/ 3 consonants
str_view(str_w, '[aeiouy]{3,}', match = TRUE) #have 3 or more vowels in a row
str_view(str_w, '([aeiouy][^aeiouy]){2,}', match = TRUE) #have 2 or more vowels-consonant pairs in a row

#2-4
# each (.) corresponds to a letter and the \\# references this letter
str_view(str_w, '^(.)(.*\\1$|\\1?$)', match = TRUE) #start and end w/ same character
str_view(str_w, '([A-Za-z][A-Za-z]).*\\1', match = TRUE) #contain a repeated pair of letters
str_view(str_w, '([a-z]).*\\1.*\\1', match = TRUE) #contain one letter repeated in at least 3 places

#### Tools ####
#1
stringr::words[str_detect(stringr::words, "^x.*|.*x$")] #start or end w/ x
 #start w/ a vowel and end w/ a consonant


#1-2
colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c("\\b(", str_c(colors, collapse = "|"), ")\\b")

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(sentences, "[A-Za-z]+") %>% head() #first words from each sentence

pattern_ing <- "\\b[A-Za-z]+ing\\b"
words_ing <- unlist(str_extract_all(sentences, pattern_ing)) #all words ending in 'ing'
head(unique(words_ing))

#### stringi ####
#stringr is built upon the stringi package. stringr contains 42 functions, stringi contains 234 functions