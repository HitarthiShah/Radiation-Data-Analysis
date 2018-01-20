library(data.table)
library(lubridate)
library(plotly)
library(shinydashboard)
library(leaflet)

df_reactor_ui <- fread("/Users/uditagupta93/Desktop/RShiny/rshiny/exposure.csv");

dashboardPage(
  dashboardHeader(title = "Radiation Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Population Exposed", tabName = "when"),
      menuItem("Reactor Locations", tabName = "where")
    )
  ),
  dashboardBody(
    
    
    tabItems(
      # First tab content
      tabItem(tabName = "when",
              fluidPage(
                titlePanel("Population Exposed"),
                sidebarLayout(position = "right",
                              sidebarPanel(

                                selectInput("year",
                                            label = "Year",
                                            choices = c("1990", "2000", "2010"),
                                            selected = "2000"),

                                selectInput("distance",
                                            label = "Distance(km)",
                                            choices = c("30","75","150","300","600","1200"),
                                            selected = "150"),

                                selectInput("country",
                                            label = "Country",
                                            choices = unique(df_reactor_ui$Country),
                                            selected = "SWEDEN"),

                                submitButton("Submit")
                              ),

                              mainPanel(
                                plotlyOutput("myplotwhen")
                              )
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "where",
              fluidPage(
                titlePanel("Reactor Locations"),

                sidebarLayout(position = "right",
                              sidebarPanel(

                                selectInput("year_lat_long",
                                            label = "Year",
                                            choices = array(2015:2018),
                                            selected = 2016),

                                selectInput("month_lat_long",
                                            label = "Month",
                                            choices = array(1:12),
                                            selected = 4),

                                submitButton("Submit")
                              ),

                              mainPanel(
                                leafletOutput("myplotwhere")
                              )
                )
              )
      )
    )
  )
)