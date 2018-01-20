library(data.table)
library(lubridate)
library(plotly)
library(shinydashboard)
library(leaflet)
library(dplyr)

shinyServer(
  function(input, output) {
    
    setwd("/Users/uditagupta93/Desktop/RShiny/rshiny/measurement/")
    files = list.files(path = "/Users/uditagupta93/Desktop/RShiny/rshiny/measurement/",pattern = ".csv")
    temp <- lapply(files, fread, sep=",")
    df_lat_long <- rbindlist( temp )
    
    colnames(df_lat_long) <- c("lat","long", "unit", "year", "month");
    
    df_reactor_server <- fread("/Users/uditagupta93/Desktop/RShiny/rshiny/exposure.csv");
    
    # df_lat_long <- fread("/Users/uditagupta93/Desktop/RShiny/rshiny/measurement/measure_1.csv");
    
    output$myplotwhen <- renderPlotly({
      new_data_reactor = filter(df_reactor_server,
                        df_reactor_server$Country == input$country
      )

      column = paste( "p" , substr(input$year, 3,4) , "_", input$distance, sep = "")
      print(column)
      
      new_data_reactor$column  <- new_data_reactor %>% dplyr:: select(starts_with(column))
      
      plot_ly(
        x = new_data_reactor$Plant,
        y = unlist(new_data_reactor$column, use.names=FALSE),
        type = "bar"
      )
    });
    
    output$myplotwhere <- renderLeaflet({
      
      
      new_data_lat_long = filter(df_lat_long,
                        df_lat_long$year == input$year_lat_long &
                          df_lat_long$month == input$month_lat_long
                          
      )
      
      labs <- as.list(new_data_lat_long$unit)
      
      m <- leaflet(new_data_lat_long) %>% 
        addTiles() %>%  addMarkers(
          data = new_data_lat_long, lat = ~lat, lng =~long, 
                           label = lapply(labs, HTML),
                            clusterOptions = markerClusterOptions()
        )
    });
  }
)