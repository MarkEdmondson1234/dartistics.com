# The idea was to get the Twitter handle for every student as part of the introductions.
# Add those to a .csv that is just open in RSTudio. Then, run a script that pulls the
# last 30 days of tweets from all of the students and generates a word cloud.
# But... 1.5 hours in, and I can't get twitteR to authenticate.


library(twitteR)
library(dplyr)

# Authorize Twitter
consumerKey <- "PBZ1OOC61Fa4Rvu00weipJcHH"
consumerSecret <- "m6OlgtM0iWpKUbnsMrPG4pv2NJC6BJVcZhXpUsImFnOCTaK6yf1"
accessToken <- "9459132-AQbfbaDUhMvPlQNzjgcIXJWhGmnb22sJ9jckyctyUG"
accessTokenSecret <- "FvGseA55680hAOEgHWyMCSynF9GVvm49a97nquOLMqLkv"
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)


# Curses!!! CANNOT get this to run without generating the following:
#     Error in check_twitter_oauth() : OAuth authentication error:
#     This most likely means that you have incorrectly called setup_twitter_oauth()'
# Lots of StackExchange chatter on it, but none of the fixes seem to work.
# Seems to be something Mac-related, I think.
