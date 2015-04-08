
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(httr)
library(RCurl)
library(XML)
library(stringr)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

shinyServer(function(input, output) {
  
  output$image <- renderUI({
    
    if (input$url != "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"){
      url_src = input$url
    }
    else
      url_src <- "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"
    
    tags$img(src = url_src, width = "200px")
    
  })
  
  output$debug <- renderText({
    
    if (input$url != "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"){
      url_src = input$url
    }
    else
      url_src <- "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"
    
    u <- paste("http://images.google.com/searchbyimage?hl=",input$country,"&image_url=",url_src,sep="")
    useragent <- "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
    html <- getURL(u,ssl.verifypeer = FALSE, httpheader = c('User-Agent' = useragent))
    doc <- htmlParse(html)
    #HTML(doc,file="test.html")
    links <- xpathSApply(doc, "//a/@href")
        
    u <- paste(links[[1]],"&gws_rd=ssl",sep="")
    u
    
  })
  
  # Filter data based on selections
  output$table <- renderDataTable({
#    data <- mpg
#     if (input$cyl != "All"){
#       data <- data[data$cyl == input$cyl,]
#     }
#     if (input$trans != "All"){
#       data <- data[data$trans == input$trans,]
#     }
#    data

    if (input$url != "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"){
      url_src = input$url
    }
    else
      url_src <- "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"
    
    u <- paste("http://images.google.com/searchbyimage?hl=",input$country,"&image_url=",url_src,sep="")
    useragent <- "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
    html <- getURL(u,ssl.verifypeer = FALSE, httpheader = c('User-Agent' = useragent))
    doc <- htmlParse(html)
    #HTML(doc,file="test.html")
    links <- xpathSApply(doc, "//a/@href")
    
    u <- paste(links[[1]],"&gws_rd=ssl",sep="")
    useragent <- "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
    html <- getURL(u,ssl.verifypeer = FALSE, httpheader = c('User-Agent' = useragent), encoding='UTF8')
    #HTML(doc,file="list.html")
    doc <- htmlParse(html)
    # extraction
    # on remplit le dataframe
    attrs <- xpathApply(doc, "//h3[@class='r']/a/@href")  
    attrs2 <- xpathApply(doc, "//h3[@class='r']/a")   
    #attrs3 <- xpathApply(doc, "//div[@class='s']/div[1]/div[@class='th _lyb']/a/img/@src")
    free(doc)
    links <- sapply(attrs, function(x) paste('<a target="_blank" href="',x[[1]],'">',x[[1]],'</a>',sep=""))
    links_src <- sapply(attrs, function(x) x[[1]]) 
    titles <- sapply(attrs2, function(x) xmlValue(x[[1]]))
    #images <- sapply(attrs3, function(x) x[[1]])
    #get 20 premiers différents
    
    #analyser chaque url
    analyses <- c()
    for (i in 1:length(links)) {
      analyses[i] <- links_src[i]
    }
    
    df <- data.frame(titles,links,analyses)       
 
    df
    
  })  
  
})
