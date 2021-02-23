# Set up libraries

library(shiny)
library(tidyverse)
library(bslib)

source("res_sed.R")


my_theme <- bs_theme(
    bg = "white",
    fg = "#324452",
    primary = "#97BDBF",
    base_font = font_google("Poppins")
)
# html color codes: https://htmlcolorcodes.com/color-names/

ui <- fluidPage(theme = my_theme,
    
    navbarPage("Wildfire & Water Quality in the Central Sierra Nevada",
                           tabPanel("Home",
                                    sidebarLayout(
                                        sidebarPanel(img(src = "ARLogo_Horiz - TRANS.png", height = 70),
                                                     img(src = "F_F-RGB-LOGO-Trans-Bkgrnd.png", height = 100)),
                                        mainPanel(img(src = "El Dorado National Forest - Jose Antonio Galloso - 3.jpg", height = 300),
                                                  h3("Our Project"),
                                                  p("Forests to Faucets is a group master's thesis project at the ", a(href="https://bren.ucsb.edu/", " Bren School of Environmental and Science Management at UC Santa Barbara."), "We will identify locations for fuels reduction to maximize benefits to river ecosystems and clean water supply. This model will be looking at fire and water processes in the Cosumnes, American, Bear, and Yuba (CABY) river regions in the Sierra Nevada Forests."),
                                                  h4("Wildfire threatens river ecosystems and clean water supply by increasing erosion and sediment delivery to rivers and streams."),
                                                  p("Forests are a critical piece of California’s natural water infrastructure. However, high severity wildfires pose a significant threat to river ecosystems and clean water supply in the Sierra Nevada. High severity wildfires destroy vegetation and alter soil properties, leading to an increase in erosion and an influx of sediment into rivers and streams. Sediment can interfere with drinking water treatment, reduce reservoir storage capacity, and harm fish and amphibians. Climate change, drought, and a century of fire suppression have caused a shift toward larger, high severity fires. Fuel treatments like prescribed fire can help reduce future fire severity by removing fuel from the forest floor. However, limited funding, staff capacity, public opinion, and arduous permitting have led to a backlog of areas in need of treatment."),
                                                  h4("Prescribed fire can protect river ecosystems and clean water supply by reducing the severity of future wildfires."),
                                                  p("Prescribed burns, mechanical thinning, and other fuels treatments are often located inefficiently based on post-fire community salience, political factors, and a lack of data on the projected impacts of fuel treatments. Potential benefits to water quality are generally not taken into account in planning the location of fuels reduction treatments. Forests to Faucets will design a prioritization model for locating prescribed burns in the watersheds of the Cosumnes, American, Bear, and Yuba (CABY) rivers on the western slope of the Sierra Nevada. This model will prioritize sub-catchments based on the risk of erosion after a catastrophic fire, the potential of prescribed fire to mitigate that risk, treatment feasibility, and existing fuel treatment priorities.")) 
                                    )
                           ),
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
                                        mainPanel("Scatterplot of reservoir capacity versus percent capacity remaining with points of the selected size class highlighted",
                                                  plotOutput("res_sed_plot"))
                                    ))
                )
                
)

server <- function(input, output) {
    res_sed_reactive <- reactive ( {
        
        res_sed %>%
            filter(percent_remaining>=input$slider2[1] & percent_remaining<=input$slider2[2])
    })
    
    output$res_sed_plot <- renderPlot(
        ggplot(data = res_sed_reactive(), aes(x = year, y = percent_remaining)) +
            geom_point(aes(color = stor_cap_af))+
            scale_x_log10()+
            scale_color_gradient(trans = "log10")+
            theme_minimal()
        
    )
    
}

shinyApp(ui = ui, server = server)


