#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidycensus)
library(dplyr)
library(tidyr)
library(leaflet)
library(stplanr)
library(rgdal)
library(sp)
library(tmap)

load(url("https://github.com/renwah/GIS-III/blob/master/finalproj.RData?raw=True"))

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("CTA ADA Accessibility and 2017 Census Tract Data"),
   
   # Sidebar with a slider input for year, numeric input for population 
   sidebarLayout(
     sidebarPanel(
       selectInput(inputId = "pop_type", "Choose a population:",
                   choices = 
                   c('Total Population' = total_pop_sp,
                        'Percentage with ambulatory disabilities' = amb_perc_sp, 
                        'Median Household Income' = inc_sp,
                        'Percentage Black' = black_perc_sp
                      ))
       
       
     ),
   
   # Sidebar with a slider input for number of bins 
  
      # Show a plot of the generated distribution

   mainPanel(
     # plotOutput("distPlot"),
     leafletOutput(outputId = "map")
     #dataTableOutput("table")
   )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$map <- renderLeaflet({
    
   population <- input$pop_type

    leaflet() %>% addPolylines(data=llines, group = "L Station Network") %>% 
      addMarkers(data=lstops, group =  "L Station Network") %>%
      addPolygons(data=population , group = "Demographics", color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5,
                  fillColor = ~colorQuantile("YlOrRd", total)(total),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE)) %>%
      addTiles()
    
    
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

