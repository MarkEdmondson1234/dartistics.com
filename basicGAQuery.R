# Basic script to pull some data from Google Analytics with googleAnalyticsR

# Load the packages that enable authenticating Google Analytics and then pulling data.
library(googleAnalyticsR)
library(googleAuthR)

# Load up some other packages that we will almost certainly use
library(dplyr)

# Set the client ID and client secret. These come from the Google app setup
options("googleAuthR.client_id" = "408865981365-hg38h9mcjc961emjmq50rrfi684m4hu1.apps.googleusercontent.com")
options("googleAuthR.client_secret" = "OvlxA-ITf8oYSeuN7lGYC-l1")

# Authorize the Google Analytics account
googleAuthR::gar_auth()

# Set the variables we want to use in our query
s.viewId <- "ga:67333037"
s.dateRange <- c("2016-06-01","2016-08-12")
s.dimensions <- c("ga:date","ga:medium","ga:deviceCategory")
s.metrics <- c("ga:sessions","ga:pageviews")
s.segment <- NULL
s.filter <- NULL
s.maxResults <- -1

# Call the Google Analytics API. The result will put data in a 
# data frame called "gaData"
gaData <- google_analytics_4(viewId = s.viewId, 
                             date_range = s.dateRange, 
                             metrics = s.metrics, 
                             dimensions = s.dimensions,
                             filtersExpression = s.filter,
                             segments = s.segment,
                             anti_sample = TRUE)