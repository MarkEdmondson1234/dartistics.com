## in server.R
library(googleAuthR)
library(googleAnalyticsR)
library(shiny)
library(highcharter)

function(input, output, session){
  
  ## Get auth code from return URL
  token <- callModule(googleAuth, "login")
  
  ga_accounts <- reactive({
    req(token())
    
    with_shiny(ga_account_list, shiny_access_token = token())
    
  })
  
  selected_id <- callModule(authDropdown, "auth_menu", ga.table = ga_accounts)
  
  gadata <- reactive({
    
    req(selected_id())
    gaid <- selected_id()
    with_shiny(google_analytics,
               id = gaid,
               start=input$date_select[1], end=input$date_select[2], 
               metrics = c("sessions"), 
               dimensions = c("date"),
               shiny_access_token = token())
  })
  
  output$something <- renderHighchart({
    
    ## only trigger once authenticated
    req(gadata())
    
    gadata <- gadata()
    
    ## creates a line chart using highcharts
    hchart(gadata, "line" , hcaes(x = date, y = sessions))
    
  })
  
}