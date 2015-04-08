
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# 
# shinyUI(bootstrapPage(
# 
#   textInput("url", label = h3("URL Image"), value = ""),
#   tags$style(type='text/css', "#url { width: 100%; }"),
#     
#   tableOutput('contents'),
#   
#   dataTableOutput(outputId="table")
# 
# ))


library(shiny)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("Image Price Comparison"),
    
    # Create a new Row in the UI for selectInputs
     fluidRow(
       column(8, 
          textInput("url", label = h3("URL Image"), value = "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"),
          tags$style(type='text/css', "#url { width: 100%; }")
       ),
       column(4, 
              selectInput("country", 
                          label = h3("Country"), 
                          c("com","fr","es","ru"))
       )        
     ),

#     fluidRow(
#       column(4,
#         htmlOutput('image')     
#       ),
#       column(8,
#         dataTableOutput(outputId="table")     
#       )
#     ),  
      
    fluidRow(
      htmlOutput('image'),
      dataTableOutput(outputId="table"),
      tableOutput('debug')
    )    
  )  
)