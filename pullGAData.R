install.packages("googleAuthR")
install.packages("googleAnalyticsR")

## setup
library(googleAnalyticsR)
library(googleAuthR)

## This should send you to your browser to authenticate your email.
## Authenticate with an email that has access to the Google Analytics View you want to use.
ga_auth()

## get your accounts
account_list <- google_analytics_account_list()

## pick a profile with data to query
ga_id <- 66885314


gaData <- google_analytics_4(ga_id, 
                             date_range = c("2016-01-01","2016-07-31"), 
metrics = c("sessions","pageviews","entrances","bounces"),
dimensions = c("date","channelGrouping","deviceCategory"),
anti_sample = TRUE)

write.csv(gaData,"gadata_large_example.csv")