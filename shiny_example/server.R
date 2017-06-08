#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

## in server.R
library(shiny)

function(input, output){
  
  ## our reactive object for data
  the_data <- reactive({
    
    req(input$metric)
    req(input$device)
    req(input$channel)
    
    ## get the data from csv
    plot_data <- read.csv("../data/gadata_example_2.csv", stringsAsFactors = FALSE)
    plot_data <- plot_data[plot_data$channelGrouping == input$channel, ]
    plot_data <- plot_data[plot_data$deviceCategory == input$device, c("date", input$metric)]
    
  })
  
  output$plot1 <- renderHighchart({
    
    ## this is a roadblock so this function won't fire until the_data is non-NULL
    req(the_data())
    
    ## do this as it make debugging a lot easier
    plot_data <- the_data()
    
    hchart(plot_data, "line" , hcaes(x = date)) %>% 
      hc_add_series(plot_data[[input$metric]])
    
  })
  
  output$max_text <- renderText({
    
    ## this is a roadblock so this function won't fire until the_Data is non-NULL
    req(the_data())
    
    ## do this as it make debugging a lot easier
    plot_data <- the_data()

    paste("The max is: ", max(plot_data[[input$metric]]))
    
  })
  
}