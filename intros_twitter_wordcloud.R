# The idea was to get the Twitter handle for every student as part of the introductions.
# Add those to a .csv that is just open in RSTudio. Then, run a script that pulls the
# last 30 days of tweets from all of the students and generates a word cloud.

# To get the Twitter data
library(twitteR)

# To generate the wordcloud
library(tm)
library(SnowballC)
library(wordcloud)

# Authorize Twitter
consumerKey <- "PBZ1OOC61Fa4Rvu00weipJcHH"
consumerSecret <- "m6OlgtM0iWpKUbnsMrPG4pv2NJC6BJVcZhXpUsImFnOCTaK6yf"
accessToken <- "9459132-AQbfbaDUhMvPlQNzjgcIXJWhGmnb22sJ9jckyctyUG"
accessTokenSecret <- "FvGseA55680hAOEgHWyMCSynF9GVvm49a97nquOLMqLkv"
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)

# Get the list of usernames
usernames <- read.csv("intros_twitter_wordcloud_usernames.csv", stringsAsFactors = FALSE)

# Set the start date as the last 90 days
startDate <- as.character(Sys.Date()-90)

# Initialize a data frame that we'll append tweets to. We only want the 
# username and the tweet.
tweetData <- data.frame(username = character(),tweet = character())

# Pull the tweets for each username and put them in an overall data frame
for (i in 1:nrow(usernames)){
  # pull the list of tweets and put them in a data frame
  userTweets <- twListToDF(searchTwitter(paste('from:',
                                               usernames$username[i],"'",sep=""),
                                         n = 1e4, since = startDate))
  
  # append these tweets to the master data set
  tweetData <- rbind(tweetData,data.frame(username = userTweets$screenName, tweet = userTweets$text))
}

# Make a word cloud from the tweets

# Special characters in the tweets will bork the tm_map stuff later on, so
# find all of those and replace them with ""
tweetData$tweet <- lapply(tweetData$tweet, function(x) iconv(x, from = "latin1", to = "ASCII", sub=""))

# Create a corpus of the tweet text
tweetCorpus <- Corpus(VectorSource(tweetData$tweet))

# Convert the corpus to a plain text document.
tweetCorpus <- tm_map(tweetCorpus, PlainTextDocument)

# Remove all punctuation and stopwords. 
tweetCorpus <- tm_map(tweetCorpus, removePunctuation)
tweetCorpus <- tm_map(tweetCorpus, removeWords, stopwords('english'))

# Perform stemming
tweetCorpus <- tm_map(tweetCorpus, stemDocument)

#Plot the wordcloud
wordcloud(tweetCorpus, max.words = 200, random.order = FALSE)