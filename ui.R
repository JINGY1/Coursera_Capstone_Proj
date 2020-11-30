library(shiny)

shinyUI(fluidPage(

    titlePanel("Word Prediction App"),

    sidebarLayout( 
        
        position = "left",
        fluid = TRUE,          
                   
        sidebarPanel(
            width = 6, 
            
            # Instruction for user
            textInput("text", label = ('Please Enter Text Here'), value = ''),
            
            
            column(4, selectInput("slider", "Number of Prediction:", c(10,20,30,40,50))
                   ),
            
            # Table1 output
            dataTableOutput('table1')
        ),


        mainPanel(
            width = 6,
            
            wellPanel(
                # Link to github
                helpText(a('More information on the app',
                           href='https://github.com/JINGY1/Coursera_Capstone_Proj',
                           target = '_blank'))
        ),
        
        tabsetPanel(
            tabPanel("Predicted Sentence", tableOutput('table2')), 
            tabPanel("WordCloud Plot", plotOutput('wordcloud'))
        )
        
        )
    )
))
