# Set up libraries

library(shiny)
library(tidyverse)
library(bslib)
library(tmap)

# Read in sources
 source("res_sed.R")
 source("fire_hist.R")
 source("feas.R")
 source("watersheds.R")

# Set up a theme
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
                                            radioButtons("selectWS", label = h3("Select sub-watershed of interest:"), 
                                                    choices = list("Cosumnes River Watershed" = 1, 
                                                                   "American River Watershed" = 2, 
                                                                   "Bear River Watershed" = 3, 
                                                                   "Yuba River Watershed" = 4), 
                                                    selected = 1)),
                                        mainPanel(plotOutput("watersheds_plot"),
                                                  p("Data citation: ", a(href="https://services6.arcgis.com/MtSzpOZ2FMytnchL/arcgis/rest/services/CABY_BOUNDARIES/FeatureServer", "CABY IRWM HUC-8 watersheds")))
                                    )),
                           tabPanel("Fire History",
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("selectYear", 
                                                      label = h3("Select year:"), 
                                                      choices = c(2000:2019),
                                                      selected = 2017,
                                                      multiple = TRUE)
                                        ),
                                        mainPanel(plotOutput("fire_hist_plot"),
                                                  p("Data citation: ", a(href="https://frap.fire.ca.gov/mapping/gis-data/", "CAL FIRE/USFS historic fire perimeters")))
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
                                        mainPanel(plotOutput("feas_plot"),
                                                  p("Data citations: ", a(href="https://frap.fire.ca.gov/mapping/gis-data/", "CAL FIRE/USFS historic fire perimeters, "),
                                                    a(href="http://silvis.forest.wisc.edu/data/wui-change/", "UW-Madison Silvis Lab WUI, "),
                                                    a(href="https://enterprisecontentnew-usfs.hub.arcgis.com/datasets/roadless-areas-2001-roadless-rule-feature-layer?geometry=-121.199%2C39.043%2C-119.157%2C39.416", "USFS IRAs, "),
                                                    a(href="https://apps.wildlife.ca.gov/bios/", "CEC powerlines, "),
                                                    a(href="https://enterprisecontentnew-usfs.hub.arcgis.com/datasets/hazardous-fuel-treatment-reduction-polygon-feature-layer?geometry=-59.783%2C-29.487%2C-161.736%2C87.322", "USFS hazardous fuel treatment reduction, "),
                                                    a(href="https://iftdss.firenet.gov/landing_page/", "IFTDSS LANDFIRE Landscape")))
                                    )),
                           tabPanel("Reservoir Sedimentation",
                                    sidebarLayout(
                                        sidebarPanel(
                                            sliderInput("slider2", 
                                                        label = h3("Select percent reservoir capacity remaining:"), 
                                                        min = 0, 
                                                        max = 100, 
                                                        value = c(0, 100))),
                                        mainPanel(plotOutput("res_sed_plot"),
                                                  p("Data citation: ", a(href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2007WR006703", "Minear & Kondolf (2009) reservoir percent capacity remaining")))
                                    ))
                )
                
)

server <- function(input, output) {
    res_sed_reactive <- reactive ( {
        
        res_sed %>%
            filter(percent_remaining>=input$slider2[1] & percent_remaining<=input$slider2[2])
    })
    
    output$res_sed_plot <- renderPlot(
        ggplot(data = res_sed_reactive(), aes(x = stor_cap_af, y = percent_remaining)) +
            geom_point(aes(color = stor_cap_af))+
            scale_x_continuous(trans = "log10", limits = c(1e2,1e6), label = comma_format(accuracy = 1))+
            scale_y_continuous(limits = c(0,100))+
            scale_color_gradient(trans = "log10")+
            labs( x = "Reservoir Capacity (acrefeet)",
                  y = "Percent capacity remaining",
                  color = "Reservoir Capacity (af)") +
            theme_minimal()+
            annotation_logticks(sides = "b")
    )
    
    output$feas_plot <- renderPlot( {
        base_plot <- ggplot() +
            geom_sf(data = CABY, color = "red", fill = "white") +
            theme_void() +
            coord_sf(xlim = c(-422820,4740), ylim = c(9265042,9765928))

        if(all(c(1) %in% input$checkGroup)) {
            base_plot <- base_plot +  geom_raster(data = veg_rast,
                                                 aes(x = x, y = y),
                                                 fill = "darkgrey") }

        if(all(c(2) %in% input$checkGroup)) {
            base_plot <- base_plot +  geom_raster(data = firehist_rast,
                                                  aes(x = x, y = y),
                                                  fill = "darkgrey") }

        if(all(c(3) %in% input$checkGroup)) {
            base_plot <- base_plot +  geom_raster(data = fueltreat_rast,
                                                  aes(x = x, y = y),
                                                  fill = "darkgrey") }

        if(all(c(4) %in% input$checkGroup)) {
            base_plot <- base_plot +  geom_raster(data = WUI_rast,
                                                  aes(x = x, y = y),
                                                  fill = "darkgrey") }

        if(all(c(5) %in% input$checkGroup)) {
            base_plot <- base_plot +  geom_raster(data = powerlines_rast,
                                                  aes(x = x, y = y),
                                                  fill = "darkgrey") }

        if(all(c(6) %in% input$checkGroup)) {
            base_plot <- base_plot +  geom_raster(data = roadless_rast,
                                                  aes(x = x, y = y),
                                                  fill = "darkgrey") }

        base_plot

        }) %>% 
        bindCache(input$checkGroup)

    fire_hist_reactive <- reactive ( {
        
        fire_hist %>%
            mutate(highlight = ifelse(year %in% input$selectYear, "yes", "no"))
    })
    
    output$fire_hist_plot <- renderPlot(
        ggplot(data = fire_hist_reactive(), aes(x = year, y = sum, fill = highlight)) +
            geom_col() +
            scale_fill_manual(values = c("yes"="tomato", "no" ="gray"), guide = FALSE)+
            labs( x = "Year",
                  y = "Total Area Burned (ac)") +
            theme_minimal() +
            scale_x_continuous(expand = c(0,0),
                               breaks = seq(2000, 2020, by = 2)) +
            scale_y_continuous(expand = c(0,0))
    )
    
    caby_reactive <- reactive ( {
        
        caby %>% 
            mutate(highlight = ifelse(shinycode %in% input$selectWS, "yes", "no"))
        
    })
    
    output$watersheds_plot <- renderPlot(
        ggplot(data = caby_reactive()) +
            geom_sf(aes(fill = highlight), color = "white") +
            scale_fill_manual(values = c("yes"="tomato", "no" ="gray"))+
            labs( x = "Longitude",
                  y = "Latitude") +
            theme_minimal() +
            scale_x_continuous(expand = c(0,0)) +
            scale_y_continuous(expand = c(0,0)) +
            theme(legend.position = "none")
    )
}

shinyApp(ui = ui, server = server)


