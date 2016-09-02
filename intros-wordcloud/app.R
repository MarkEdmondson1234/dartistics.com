# Shiny application that generates a word cloud of tweets used by
# by all users in a Google Sheet over the past ~7 days. This data
# gets sampled, so it is not a precise count.

library(shiny)
library(dplyr)
library(htmlwidgets)
library(DT)
library(googlesheets) # To get the list of usernames
library(VennDiagram)

# To get the Twitter data
library(twitteR)
library(rjson)
library(httr)

# To extract the hashtags
library(stringr)

# To generate the wordcloud
library(tm)
library(SnowballC)
library(wordcloud)

# Set how far back we want to go
numDays <- 10
startDate <- as.character(Sys.Date()-numDays)

# Authorize Twitter
consumerKey <- "PBZ1OOC61Fa4Rvu00weipJcHH"
consumerSecret <- "m6OlgtM0iWpKUbnsMrPG4pv2NJC6BJVcZhXpUsImFnOCTaK6yf"
accessToken <- "9459132-AQbfbaDUhMvPlQNzjgcIXJWhGmnb22sJ9jckyctyUG"
accessTokenSecret <- "FvGseA55680hAOEgHWyMCSynF9GVvm49a97nquOLMqLkv"
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)

# Pull the list of usernames for the selected list

  # Set the ID for the source Google Sheets workbook
  sourceBook <- gs_key("1C94awbgArrbaeEEdD6y_csKxg7RU9MFH-K-_CNgY23U")
  
  # Load the values from the source (the form responses)
  surveyResponses <- gs_read(sourceBook, ws = "Form Responses 1")
  
  # Rename the columns
  colnames(surveyResponses) <- c("Timestamp","Analytics_Tools","Username")

  ###################
  # Get info for the word cloud
  # Pull just the usernames where a value was entered
  usernames <- surveyResponses$Username[!is.na(surveyResponses$Username)]
  
  # Remove the "@" across the board
  usernames <- gsub("^@","",usernames)
  
  ###################
  # Get info for the Venn Diagram
  catCounts <- count(surveyResponses,Analytics_Tools) # Count each category
  
  # Assign counts to variables. There is a possibility that any of the values would have 
  # NO responses, so there is a check for each one to set to zero in that case.
  ct_GAAA <- as.numeric(catCounts[catCounts$Analytics_Tools=="Google Analytics AND Adobe Analytics",2])
  if(is.na(ct_GAAA)){ct_GAAA <- 0}
  
  ct_GA <- as.numeric(catCounts[catCounts$Analytics_Tools=="Google Analytics",2]) 
  if(is.na(ct_GA)){ct_GA <- 0}
  ct_GA <- ct_GA + ct_GAAA
  
  ct_AA <- as.numeric(catCounts[catCounts$Analytics_Tools=="Adobe Analytics",2]) 
  if(is.na(ct_AA)){ct_AA <- 0}
  ct_AA <- ct_AA + ct_GAAA

# Define UI for application that draws a histogram

ui <- fluidPage(
  
  titlePanel("R Class - Survey Results"),
  fluidRow(
    column(12,p(paste("A word cloud of tweets by R class attendees over",
                      "the past ~week.", sep=" ")))),
  
  # Get the list to find detail for 
  fluidRow(
    column(7, sliderInput("min_occurrences", "Minimum occurrences required:", 
                       min=1, max=10, value=3))),
  fluidRow(
    column(12,strong(textOutput("numUsers")))
  ),
  hr(),
  
  fluidRow(
    column(4, DT::dataTableOutput("top_users"), label="Top Users by # of Tweets"),
    column(8, plotOutput("wordcloud"), label="Hashtags Used (All Users)")),
  
  fluidRow(
    column(12,plotOutput("vennDiagram"))) # Show a plot of the generated distribution
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Reactive function that pulls the list of tweets for the list of usernames
  user_tweets <- reactive({
    
    # This needs the list of usernames, so we have to call that first
    userScreennames <- usernames
    
    # Due to API limits, we're going to pull the data for 20 usernames at a time
    firstuser <- 1
    lastuser <- 20
    
    while (firstuser <= length(userScreennames)){
      
      # Set the lastuser # to the last value if we're on the last pass
      if(lastuser > length(userScreennames)){
        lastuser <- length(userScreennames)
      }
      
      # This actually pulls the tweet data. The nested paste() commmands are building a
      # string like this: "from:<username>+OR+from:<username>+OR+..." It seems a bit
      # finicky as to the structure, but that seems to do the trick.
      getTweets <- paste(paste('from:',userScreennames[firstuser:lastuser],sep=""),collapse="+OR+") %>%
        searchTwitter(n = 1000, since = startDate, resultType='recent') %>%
        twListToDF() %>%
        as.data.frame()
      
      # if this is the first time through, then create a data frame. If not, then
      # append to the existing frame
      if(firstuser == 1) {
        userTweets <- getTweets
      }
      else {
        userTweets <- rbind(userTweets,getTweets)
      }
      firstuser <- firstuser + 20
      lastuser <- lastuser + 20
    }
    
    return(userTweets)
    
  })
  
   output$numUsers <- renderText({
      paste("There are",length(usernames),"members in this list. The",
           "list below only includes those who tweeted in the last week.",sep=" ")
   })
  
   output$wordcloud <- renderPlot({

    ###################
    # Make a word cloud of the hashtags used
    ###################

     userTweets <- user_tweets()
     
     # Convert this to a vector of tweets
     tweet_corpus <- Corpus(VectorSource(userTweets$text))
     
     tweet_corpus <- tm_map(tweet_corpus,
                            content_transformer(function(x) iconv(x, to='ASCII', sub='byte')),
                            mc.cores=1)
     
     tweet_corpus <- tm_map(tweet_corpus, content_transformer(tolower))
     tweet_corpus <- tm_map(tweet_corpus, content_transformer(removePunctuation))
     tweet_corpus <- tm_map(tweet_corpus, content_transformer(removeNumbers))
     tweet_corpus <- tm_map(tweet_corpus, content_transformer(function(x) removeWords(x, stopwords())))
 
     wordcloud(tweet_corpus, max.words = 500, random.order = FALSE, 
               min.freq = input$min_occurrences,
               rot.per = 0, fixed.asp=FALSE, colors=brewer.pal(6,"Dark2"))
    
  })
  
  output$top_users <- DT::renderDataTable({
    
    userTweets <- user_tweets()

     # Get the users who tweeted and the # of tweets for each
    table_data <- summarise(group_by(userTweets,screenName), numTweets = n_distinct(id)) %>%
      arrange(desc(numTweets))
    colnames(table_data) <- c("Username","# of Tweets")
    
    DT::datatable(table_data,options=list(paging = TRUE, 
                                          pageLength = 10,
                                          searching = FALSE))
    
  })
  
  output$vennDiagram <- renderPlot({
    # Only plot the Venn diagram if the input values are legit (the input values
    # are all available and the intersection area isn't greater than either individual set). 
    draw.pairwise.venn(area1 = as.numeric(ct_GA),
                       area2 = as.numeric(ct_AA),
                       cross.area = as.numeric(ct_GAAA),
                       category = c("Google Analytics","Adobe Analytics"),
                       fill = c("#F29B05","#A1D490"),
                       ext.text = TRUE,
                       ext.percent = c(0.1,0.1,0.1),
                       ext.length = 0.6,
                       label.col = rep("gray10",3),
                       lwd = 0, 
                       cex = 2,
                       fontface = rep("bold",3),
                       fontfamily = rep("sans",3), 
                       cat.cex = 1.5,
                       cat.fontface = rep("plain",2),
                       cat.fontfamily = rep("sans",2),
                       cat.pos = c(0, 0),
                       print.mode = c("percent","raw"))
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

