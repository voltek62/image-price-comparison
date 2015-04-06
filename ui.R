
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Image Price Comparison"),
  sidebarPanel(
    
    textInput("url", label = h3("URL Image"), 
              value = ""),
    
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    
    
    tags$hr(),
    
    checkboxInput('header', 'Header', TRUE),
    
  ),
  mainPanel(
    tableOutput('contents')
  )
))