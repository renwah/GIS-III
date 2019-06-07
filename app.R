
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(spData)
library(dplyr)

# Define UI for application that filters map points based on year and minimum population
ui <- fluidPage(
  
  # Application title
  titlePanel("World Population Over Time"),
  
  # Sidebar with a slider input for year, numeric input for population 
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("height",
                  "Elevation",
                  min = 100,
                  max = 5000,
                  step = 20,
                  value = 2000)
      
    ),
    
    # Show the map and table
    mainPanel(
      # plotOutput("distPlot"),
      leafletOutput("map"),
      dataTableOutput("table")
    )
  )
)

# Define server logic required to draw a map and table
server <- function(input, output) {
  
  
  output$map <- renderLeaflet({
    
    nz_try <- filter(nz_height, 
                          elevation == input$height)
    
    leaflet(data = nz_try) %>%
      addTiles() %>%
      addMarkers()
  })
  
  output$table <- renderDataTable({
    
    nz_try <- filter(nz_height, 
                          elevation == input$height)
    
    nz_try
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)