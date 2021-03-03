library(tidyverse)
library(here)
library(scales)

res_sed <- read_csv(here("244-shinyapp","Minear_and_Kondolf_est_res_sed_modified_AH.csv")) %>% 
  rename('percent_remaining' = "%  capacity remaining") %>% 
  rename('stor_cap_2020' = "2020") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(stor_cap_af= stor_cap_m3*0.000810714) %>% 
  mutate(stor_cap_2020= stor_cap_2020*0.000810714) %>% 
  dplyr::select(dam_name, drainage_sqkm, year, stor_cap_af, stor_cap_2020, percent_remaining)

# test

ggplot(data = res_sed, aes(x = stor_cap_af, y = percent_remaining)) +
  geom_point(aes(color = stor_cap_af))+
  scale_x_continuous(trans = "log10", limits = c(1e2,1e6), label = comma_format(accuracy = 1))+
  scale_color_gradient(trans = "log10")+
  labs( x = "Reservoir Capacity (acrefeet)",
        y = "Percent capacity remaining") +
  theme_minimal()+
  annotation_logticks(sides = "b")
