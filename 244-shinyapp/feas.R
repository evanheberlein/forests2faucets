## Feasibility Map

library(tidyverse)
library(sf)
library(here)
library(raster)

# Read in CABY Boundary
CABY <- read_sf(here("data", "CABY_Boundary", "CABY_Boundary.shp")) %>% 
  st_transform(6269)

# Read in rasters
veg_rast <- here("data", "Feasibility_data", "Feas_Veg.tif") %>% 
  raster() %>% 
  raster::rasterToPoints() %>% 
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

