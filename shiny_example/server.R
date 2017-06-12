library(shiny)
library(highcharter)
library(dplyr)

function(input, output){
  
  raw_data <- reactive({
    
    ## get the data from csv
    read.csv("../data/gadata_example_2.csv", stringsAsFactors = FALSE)
    
  })
  
  ## our reactive object for data
  plot_data <- reactive({
    
    req(raw_data())
    req(input$metric)
    req(input$device)
    req(input$channel)
    
    ## get the data from csv
    plot_data <- raw_data()
    
    ## filter down to choices
    plot_data <- plot_data[plot_data$channelGrouping %in% input$channel, ]
    plot_data <- plot_data[plot_data$deviceCategory %in% input$device, c("date", input$metric)]
    
    plot_data$metric <- plot_data[[input$metric]]

    ## aggregate on metric
    plot_data %>% 
      group_by(date) %>% 
      summarise(metric_sum = sum(metric))
    
  })
  
  chi_data <- reactive({
    
    req(raw_data())
    req(input$metric)
    req(input$device)
    req(input$channel)
    
    raw_data <- raw_data()
    
    metric_data <- raw_data[, c("channelGrouping","deviceCategory", input$metric)]
    metric_data$metric <- metric_data[[input$metric]]
    
    metric_data <- metric_data[metric_data$deviceCategory %in% input$device, ]
    metric_data <- metric_data[metric_data$channelGrouping %in% input$channel, ]
    
    metric_data %>% 
      select(channelGrouping, deviceCategory, metric) %>%
      group_by(channelGrouping, deviceCategory) %>% 
      summarise(metric_sum = sum(metric)) %>% 
      tidyr::spread(channelGrouping, metric_sum)
    
  })
  
  output$plot1 <- renderHighchart({
    
    ## this is a roadblock so this function won't fire until the_data is non-NULL
    req(plot_data())
    
    ## do this as it make debugging a lot easier
    plot_data <- plot_data()
    
    hchart(plot_data, "line" , hcaes(x = date)) %>% 
      hc_add_series(plot_data$metric_sum)
    
  })
  
  output$table <- renderTable({
    req(chi_data())
    
    chi_data()
  })
  
  output$chi_text <- renderText({
    
    ## this is a roadblock so this function won't fire until the_Data is non-NULL
    req(chi_data())
    req(input$device)
    req(input$channel)
    
    ## do this as it make debugging a lot easier
    chi_data <- chi_data()

    chi_test <- chisq.test(chi_data[-1])
    paste("NULL hypothesis there is no relationship between ", paste(input$device, collapse = ", "), 
          " and ", 
          paste(input$channel, collapse = ", "),
          " - ",
          chi_test$method, " Chi^2: ", chi_test$statistic, " : p-value ", chi_test$p.value)
    
  })
  
}