library(shiny)
library(highcharter)
shinyUI(
  fluidPage(
    selectInput("metric", label = "select column", choices = c("sessions",
                                                               "pageviews",
                                                               "entrances",
                                                               "bounces")),
    selectInput("device", label = "select device", choices = c("desktop", "mobile", "tablet"), multiple = TRUE),
    selectInput("channel", label = "select channel", choices = c("(Other)","Direct","Display","Email","Organic Search","Paid Search","Referral","Social","Video"), multiple = TRUE),
    tableOutput("table"),
    textOutput("chi_text"),
    highchartOutput("plot1"),
    br()
  )
)