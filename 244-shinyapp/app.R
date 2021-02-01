# Set up libraries

library(shiny)
library(tidyverse)

ui <- fluidPage(navbarPage("Wildfire & Water Quality in the Central Sierra Nevada",
                           tabPanel("Subwatersheds",
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("select", label = h3("Select sub-watershed of interest:"), 
                                                    choices = list("Cosumnes River Watershed" = 1, 
                                                                   "American River Watershed" = 2, 
                                                                   "Bear River Watershed" = 3, 
                                                                   "Yuba River Watershed" = 4), 
                                                    selected = 1)),
                                        mainPanel("Map of CABY with Subwatershed highlighted")
                                    )),
                           tabPanel("Fire History",
                                    sidebarLayout(
                                        sidebarPanel(
                                            dateInput("date", 
                                                      label = h3("Select year:"), 
                                                      value = "2014-01-01")
                                        ),
                                        mainPanel("graph showing acres burned per year in the CABY region in the last ~50 years with selected year highlighted")
                                    )),
                           tabPanel("Prescribed Fire Constraints",
                                    sidebarLayout(
                                        sidebarPanel(
                                            checkboxGroupInput("checkGroup", 
                                                               label = h3("Select feasibility constraints:"), 
                                                                choices = list("Vegetation" = 1, 
                                                                          "Fire History" = 2, 
                                                                          "Fuel Treatments" = 3,
                                                                          "Wildland Urban Interface" = 4,
                                                                          "Power Lines" = 5,
                                                                          "Roadless Areas" = 6),
                                                                selected = 1)),
                                        mainPanel("Map of CABY with different feasibility constraints turning on and off")
                                    )),
                           tabPanel("Reservoir Sedimentation",
                                    sidebarLayout(
                                        sidebarPanel(
                                            sliderInput("slider2", 
                                                        label = h3("Select Percent Reservoir Capacity Remaining"), 
                                                        min = 0, 
                                                        max = 100, 
                                                        value = c(40, 60))),
                                        mainPanel("Scatterplot of reservoir capacity versus percent capacity remaining with points of the selected size class highlighted")
                                    ))
                )
                
)

server <- function(input, output) {
    sw_reactive <- reactive ( {
        
        starwars %>%
            filter(species %in% input$pick_species)
    })
    
    output$sw_plot <- renderPlot(
        ggplot(data = sw_reactive(), aes(x = mass, y = height)) +
            geom_point(aes(color = species))
        
    )
    
}

shinyApp(ui = ui, server = server)


