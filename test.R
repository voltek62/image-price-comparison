# load packages
library(jsonlite)
library(httr)
library(RCurl)
library(dplyr)
library(XML)
library(R2HTML)
library(stringr)

 
  url_src <- "http://s3.static69.com/m/image-offre/c/e/a/f/ceaf8b49bb662bcb8fbf15858feecdea-500x500.jpg"
  u <- paste("http://images.google.com/searchbyimage?hl=en&image_url=",url_src,sep="")
  useragent <- "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
  html <- getURL(u,ssl.verifypeer = FALSE, httpheader = c('User-Agent' = useragent))
  doc <- htmlParse(html)
  #HTML(doc,file="test.html")
  links <- xpathSApply(doc, "//a/@href")
  
  free(doc)

  u <- paste(links[[1]],"&gws_rd=ssl",sep="")
  
  print(u)

  useragent <- "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
  html <- getURL(u,ssl.verifypeer = FALSE, httpheader = c('User-Agent' = useragent))
  doc <- htmlParse(html)
  #HTML(doc,file="list.html")

  # extraction
  # on remplit le dataframe
  attrs <- xpathApply(doc, "//h3[@class='r']/a/@href")
  links <- sapply(attrs, function(x) x[[1]])
  #links <- grep("http://", links, fixed = TRUE, value=TRUE)
  print(links)

  # prendre les pages suivantes
  

  free(doc)
  #return(str_detect(xmlValue(mentions[[1]]), 'Site mobile'))

  #analyse
  #retirer les doublons
  #extraire les prix




