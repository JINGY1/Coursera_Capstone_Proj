library(readr)
library(caTools)
library(tidyr)
library(dplyr)
library(quanteda)
library(wordcloud)
library(RColorBrewer)
library(tm)
library(corpus)
library(stringr)
library(tibble)

# Read and prepare data ####
setwd('D:/COURSERA/COURSE10/Capstone_Proj')
getwd()
# Read in data
blogs <- read_lines('Coursera-SwiftKey/final/en_US/en_US.blogs.txt')
news <- read_lines('Coursera-SwiftKey/final/en_US/en_US.news.txt')
twitter <- readLines('Coursera-SwiftKey/final/en_US/en_US.twitter.txt')
combinedSource <- c(blogs, news, twitter)

# Sample and combine data  
set.seed(1724)
combinedsample <- sample(combinedSource, length(combinedSource) * 0.1)

# library(knitr)
# Overview <- data.frame(
#   'FileName'=c("combine"),
#   'FileSize' = format(object.size(combinedsample),"MB"),
#   'Nrows' = length(combinedsample),
#   'TotalCharacters' = sum(nchar(combinedsample)),
#   'MaxCharacters' = max(unlist(lapply(combinedsample, function(y) nchar(y))))
# )
# kable(Overview,caption = "Basic Information")

# Split into train and validation sets
split <- sample.split(combinedsample, 0.8)
train_data <- subset(combinedsample, split == T)
valid_data <- subset(combinedsample, split == F)


# Tokenization
# Transfer to quanteda corpus format and segment into sentences (Prediction.R)
fun.corpus <- function(x) {
  corpus(unlist(corpus_reshape(corpus(x), 'sentences')))
}
train_corpus <- fun.corpus(train_data)

# Remove Ascii from dataset
train_corpus <- iconv(texts(train_corpus), from = "UTF-8", to = "ASCII", sub = "")

# Basic cleansing and tokenization
fun.tokenize <- function(x, ngram = 1, simplify = T) {
  tokens_ngrams(tokens_tolower(
    quanteda::tokens(tokenizers::tokenize_words(x), remove_symbols = TRUE,
                     remove_punct = T,
                     remove_numbers = T,
                     remove_separators = T,
                     remove_url = T
  )
  ), n=ngram, 
  concatenator = " "
  )
}

train_1gram <- data_frame(PredictWord = as.character(fun.tokenize(train_corpus, 1)))
train_2gram <- data_frame(PredictWord = as.character(fun.tokenize(train_corpus, 2)))
train_3gram <- data_frame(PredictWord = as.character(fun.tokenize(train_corpus, 3)))
  

# Frequency tables
fun.frequency <- function(x, min = 1) {
  x = x %>%
    group_by(PredictWord) %>%
    summarize(count = n()) %>%
    filter(count >= min)
  x = x %>% 
    mutate(Prob = count / sum(x$count)) %>% 
    select(-count) %>%
    arrange(desc(Prob))
}


train_1gram_prob <- fun.frequency(train_1gram)

train_2gram_prob <- fun.frequency(train_2gram) %>%
    separate(PredictWord, c('Word1', 'PredictWord'), " ")

train_3gram_prob <- fun.frequency(train_3gram) %>%
  separate(PredictWord, c('Word1', 'Word2', 'PredictWord'), " ")


# Save Data ####
saveRDS(train_1gram_prob, file = 'train_1gram_prob.rds')
saveRDS(train_2gram_prob, file = 'train_2gram_prob.rds')
saveRDS(train_3gram_prob, file = 'train_3gram_prob.rds')

