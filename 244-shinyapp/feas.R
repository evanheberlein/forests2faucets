## Feasibility Map

library(tidyverse)
library(sf)
library(here)
library(janitor)
library(raster)

# Read in rasters
veg_rast_pt <- here("data", "Feasibility_data", "Feas_Veg.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() 

veg_rast <- veg_rast_pt %>% 
  as.data.frame() %>% 
  filter(Feas_Veg > 0)

firehist_rast <- here("data", "Feasibility_data", "feas_FireHist.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() %>% 
  as.data.frame() %>% 
  filter(feas_FireHist > 0)

fueltreat_rast <- here("data", "Feasibility_data", "feas_fueltreat.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() %>% 
  as.data.frame() %>% 
  filter(feas_fueltreat > 0)

powerlines_rast <- here("data", "Feasibility_data", "feas_powerlines.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() %>% 
  as.data.frame() %>% 
  filter(feas_powerlines > 0)

roadless_rast <- here("data", "Feasibility_data", "feas_roadless.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() %>% 
  as.data.frame() %>% 
  filter(feas_roadless > 0)

WUI_rast <- here("data", "Feasibility_data", "Feas_WUI.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() %>% 
  as.data.frame() %>% 
  filter(Feas_WUI > 0)

# Read in CABY Boundary
CABY <- read_sf(here("data", "CABY_Boundary", "CABY_Boundary.shp")) %>% 
  clean_names() %>% 
  dplyr::select(rbname, acres) #%>% 
 # st_transform(CABY, st_crs(veg_rast_pt))#%>% 


# TEST
# ggplot() +
#   #geom_sf(data = CABY, color = "red") +
#   geom_raster(data = veg_rast, aes(x = x, y = y), fill = "darkgrey") +
#   geom_raster(data = firehist_rast, aes(x = x, y = y), fill = "darkgrey") +
#   geom_raster(data = fueltreat_rast, aes(x = x, y = y), fill = "darkgrey") +
#   geom_raster(data = powerlines_rast, aes(x = x, y = y), fill = "darkgrey") +
#   geom_raster(data = roadless_rast, aes(x = x, y = y), fill = "darkgrey") +
#   geom_raster(data = WUI_rast, aes(x = x, y = y), fill = "darkgrey") +
#   theme_void() + 
#   coord_sf(xlim = c(-422820,4740), ylim = c(9265042,9765928))

