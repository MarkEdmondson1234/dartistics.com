#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(highcharter)
shinyUI(
  fluidPage(
    selectInput("metric", label = "select column", choices = c("sessions",
                                                               "pageviews",
                                                               "entrances",
                                                               "bounces")),
    selectInput("device", label = "select device", choices = c("desktop", "mobile", "tablet")),
    selectInput("channel", label = "select channel", choices = c("(Other)","Direct","Display","Email","Organic Search","Paid Search","Referral","Social","Video")),
    textOutput("max_text"),
    highchartOutput("plot1")
  )
)