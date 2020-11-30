source('Prediction_Func.R')

library(shiny)
library(wordcloud)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    prediction <- reactive({

        inputText <- input$text
        input1 <-  fun.input(inputText)[1, ]
        input2 <-  fun.input(inputText)[2, ]
        prediction_num <- input$slider
        userinput <- rep(input$text,input$slider)
        
        # Predict
        prediction <- cbind(userinput,fun.predict(input1, input2, n = prediction_num))
        
    })

    # Output table1
    output$table1 <- renderDataTable(prediction()[,2:3])
    
    # Output table2
    output$table2 <- renderTable({
        data.frame(Sentence=paste(prediction()[,1],prediction()[,2]))
    })
    
    wordcloud_rep = repeatable(wordcloud)
    output$wordcloud = renderPlot(
        wordcloud_rep(
            prediction()$PredictWord,
            prediction()$Prob,
            max.words=100,
            random.order=TRUE,
            rot.per=.15,
            colors=colorRampPalette(brewer.pal(8,"Dark2"))(32),
            scale=c(6,0.5)
        ))

  
    
})
