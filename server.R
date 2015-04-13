
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
library(jsonlite)

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
  
  #path <- "http://www.diffbot.com/api/analyze?token=ffda2cb09caa868da94c844601bd8d0c&url=http://www.cromaretail.com/Nikon-COOLPIX-S3600-201-MP-Digital-Camera-%28Red%29-pc-21394-132.aspx"
  #result <- fromJSON( path )
  
  
  analyseDiffBot <- function(key,url) {
    
    #curlEscape(
    path <- paste("http://www.diffbot.com/api/analyze?token=",key,"&url=",url,sep = "")    
    
    print(path)
    
    #content <- getURL(path)
    result <- fromJSON(path)
    
    if(length(result$type)>0) {
      #print(result)
      
      if (result$type=="product")
        if (length(result$products)>0) {  
          
          #print(result$products)        
          
          if (length(result$products$offerPriceDetails)>0)
          {  
            
            print(result$products$offerPriceDetails$amount)
            
            return(c("",result$human_language,result$type,result$products$offerPriceDetails$amount,result$products$offerPriceDetails$symbol)) 
            
          }
          else
            return(c('not product page','','','',''))
        }
        else
        {
          return(c('not products','','','',''))
        }
    }
    else
       
      return(c("no result","-","-","-","-"))
    
    #if (length(result$ruleGroups)>0){
    #  return(result$ruleGroups$USABILITY$score)
    #}
    

    
  }
  
  analyseRichSnippet <- function(url) {
     
    content <- postForm("https://structured-data-testing-tool.developers.google.com/sdtt/u/0/web/validate", "url" = "http://rozetka.com.ua/nikon_coolpix_s3600_red/p420844/" ) 
    
    result <- fromJSON( content )
    
    
  }
  
  
  importVar <- function(test) {
    
    return(c("msg","Yes","toto",3))
  }
  
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
    message <- c()
    language <- c()
    type <- c()
    price <- c()
    symbol <- c()    

    for (i in 1:length(links)) {
      #result <- importVar(links_src[i])
      result <- analyseDiffBot('ffda2cb09caa868da94c844601bd8d0c',links_src[i]);
      
      print(result)
      
      if(length(result[1])>0)
        message[i]  <- result[1]
      else 
        message[i]  <- ""
      
      if(length(result[2])>0)      
        language[i] <- result[2]
      else 
        language[i]  <- ""      
      
      if(length(result[3])>0)      
        type[i]     <- result[3]
      else 
        type[i]  <- ""
      
      if(length(result[4])>0)      
        price[i]    <- result[4]
      else 
        price[i]  <- ""
      
      if(length(result[5])>0)      
        symbol[i]    <- result[5]
      else 
        symbol[i]  <- ""      
        
    }

    print(result)
    
    df <- data.frame(titles,links,message,language,type,price,symbol)       
 
    df
    
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 10) )  
  
})
