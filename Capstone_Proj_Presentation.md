Text Prediction Application
========================================================
author: Jing Yi
date: 30 Nov 2020
autosize: true
font-family: 'Cambria'


Introduction
========================================================

The objective of this project is to explore predictive text model by using backoff n-gram language modeling technique. An algorithm called 'Stupid Backoff' which similar but simpler scheme by comparing with Katz Backoff (Katx, 1987) to select next word according to frequency.

The predictive text model is build in Shiny Application provides user interface for entering word and suggests next word.

- Information in Github: https://github.com/JINGY1/Coursera_Capstone_Proj
- Shiny App: https://jingy1.shinyapps.io/Capstone_Proj_Text_Prediction/


Summary of Data
========================================================

The data used to build the model can be download here: https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip

It consists of 3 different types of English text files (blog, news and twitter).
Some basic analysis has been done in Week2 project which including building corpus and tokenization which the text has parse into n-gram model.


Table: Basic Information

|FileName |FileSize |   Nrows| TotalCharacters| MaxCharacters|
|:--------|:--------|-------:|---------------:|-------------:|
|blog     |255.4 Mb |  899288|       206824505|         40833|
|news     |257.3 Mb | 1010242|       203223159|         11384|
|twitter  |319 Mb   | 2360148|       162384825|           213|


The Predictive Text Model
========================================================

The 3 different text files is combined and randomly selected. Then separate into 80% training set and 20% validate set. Here is basic information of sampled data:

Table: Basic Information of Sample Data

|FileName |FileSize |  Nrows| TotalCharacters| MaxCharacters|
|:--------|:--------|------:|---------------:|-------------:|
|combine  |83.4 Mb  | 426967|        57112449|          4772|

Then, ascii character, symbols, punctuation, numbers, separators and URL is removed from sampled data by using quanteda R package.

The cleaned data is then tokenized into 3 different level of n-grams tokens. 


Shiny Application
========================================================

The user interface is provided for entering words and choosing number of prediction words. The result will be in 3 different form:

- Predicted word with frequencies (Prob)
- Predicted sentence
- Wordcloud

***
<img src="./App1.png" title="plot of chunk app1" alt="plot of chunk app1" width="80%" style="display: block; margin: auto;" />
