## Fire history graph

library(tidyverse)
library(sf)
library(here)
library(janitor)
library(lubridate)

# Read in data file
fire_hist <- read_sf(here("data","FireHist_CABY","FireHist_CABY.shp")) %>%
  as.data.frame() %>%
  clean_names() %>%
  mutate(year = lubridate::year(alarm_date)) %>%
  select(year, gis_acres) %>%
  group_by(year) %>%
  summarize(sum = sum(gis_acres))



