## ui.R
library(googleAuthR)
library(googleAnalyticsR)
library(shiny)
library(highcharter)

shinyUI(
  fluidPage(
    googleAuthUI("login"),
    authDropdownUI("auth_menu"),
    dateRangeInput("date_select", "Select Date", start = Sys.Date() - 30),
    highchartOutput("something")
    
  ))