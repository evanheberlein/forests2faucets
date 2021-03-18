library(tidyverse)
library(janitor)
library(forcats)

# read in data
rank_score <- read_csv("F2F_Prioritization_Rank_Score.csv") %>% 
  clean_names() %>% 
  mutate(huc_12 = fct_reorder(huc_12, american_rivers_adjusted_rank))

rank_score_long <- rank_score %>% 
  select(-equal_weight_rank, -american_rivers_rank) %>% 
  pivot_longer(cols = c(equal_weight_score, american_rivers_score, ar_adjusted_score), names_to = "scenario", values_to = "score")
  
ggplot(data = rank_score, aes(x = huc_12, y = ar_adjusted_score))+
  geom_col(fill = "darkblue")+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 90),
        axis.title.x = element_blank())+
  scale_y_continuous(expand = c(0,1), breaks = seq(0, 325, 50))+
  labs(y = "Treatment Selection Score")

ggplot(data = rank_score_long, aes(x = huc_12, y = score, fill = scenario))+
  geom_col(position = "dodge")+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 90),
        legend.title = element_blank(),
        legend.position = c(0.8, 0.8))+
  labs(y = "Treatment Selection Score")
  
