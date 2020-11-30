library(tibble)
library(quanteda)
library(dplyr)

# Load the rds source
train_1gram_prob <- readRDS(file = 'train_1gram_prob.rds')
train_2gram_prob <- readRDS(file = 'train_2gram_prob.rds')
train_3gram_prob <- readRDS(file = 'train_3gram_prob.rds')


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

# Input Function
fun.input <- function(x) {
  
  if(x == "") {
    input1 = data_frame(word = "")
    input2 = data_frame(word = "")
  }

  if(length(x) == 1) {
    y = data.frame(word=unlist(sapply(fun.tokenize(x), '[')), stringsAsFactors=F)
  }

  # If only 1 word as input
  if (nrow(y) == 1) {
    input1 = data_frame(word = "")
    input2 = y
  }   
  
  # If more than 1 word as input, take last 2 words
  else if (nrow(y) >= 1) {
    input1 = tail(y, 2)[1, ]
    input2 = tail(y, 1)
  }
  
  inputs = data_frame(words = unlist(rbind(input1,input2)))
  return(inputs)
}


# Predict Function - Stupid Backoff Algorithm

fun.predict <- function(x, y, n = 100) {
  
  if(x == "" & y == "") {
    prediction = train_1gram_prob %>%
      select(PredictWord, Prob)
    print("No input")
  }   
  else if(paste(x,y," ") %in% paste(train_3gram_prob$Word1,train_3gram_prob$Word2," ")) { 
    prediction = train_3gram_prob %>%
      filter(Word1 %in% x & Word2 %in% y) %>%
      select(PredictWord, Prob)
    print("Using 3-gram model")
  }   
  else if(y %in% train_2gram_prob$Word1) {
    prediction = train_2gram_prob %>%
      filter(Word1 %in% y) %>%
      select(PredictWord, Prob)
    print("Using 2-gram model")
  }   
  else {
    prediction = train_1gram_prob %>%
      select(PredictWord, Prob)
    print("Using 1-gram model")
  }
  
  return(prediction[1:n, ])
}
