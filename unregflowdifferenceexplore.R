library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
library(writexl)

#Data load in 
bm_raw <- read.csv("Data/BlueMesaUnreg.csv")
bm_raw$res<- "Blue Mesa"

fg_raw <- read.csv("Data/FlamingGorgeUnreg.csv")
fg_raw$res <- "Flaming Gorge"

nav_raw <- read.csv("Data/NavajoUnreg.csv")
nav_raw$res <- "Navajo"

lp_raw <- read.csv("Data/LakePowellUnreg.csv")
lp_raw$res <- "Lake Powell"

#Put data into one data frame
all_raw <- rbind(bm_raw, fg_raw, lp_raw, nav_raw)

#Filters to only include dates with data for all reservoirs and sums to annual value
all_filtered <- all_raw %>%
  group_by(datetime) %>%
  filter(n_distinct(res) == n_distinct(all_raw$res)) %>%
  ungroup()

all_annual <- all_filtered %>%
  mutate(year = year(datetime)) %>%
  group_by(year, res) %>%
  summarise(
    annual_inflow = sum(unregulated.inflow.volume, na.rm = TRUE) / 1000000,
    .groups = "drop"
  )

#Graph unreg inflow

ggplot(data = all_annual) +
  geom_line(aes(x = year, y = annual_inflow, color = res))


#Creates data frame of difference between lake powell inflow and each reservoir
flow_diff <- all_annual %>%
  pivot_wider(
    names_from = res,
    values_from = annual_inflow
  ) %>%
  mutate(across(
    -year,
    ~.data[["Lake Powell"]] - .x
  )) %>%
  pivot_longer(
    cols= -year,
    names_to = "res",
    values_to = "annual_value"
  )

# Plots differences over time
ggplot(data = flow_diff) +
  geom_line(aes(x = year, y = annual_value, color = res)) +
  labs( x = "Year", y = "Unregulated Inflow Difference from Powell (ac-ft)") 



# Puts unreg at powell on x axis and the rest on the y axis
annual_wide <- all_annual %>%
  pivot_wider(
    names_from = res,
    values_from = annual_inflow
  )

  
annual_long <- annual_wide %>%
  pivot_longer(
    cols = c('Blue Mesa', 'Flaming Gorge', 'Navajo'),
    names_to = "reservoir",
    values_to = "value_y"
  )

sheets <- list("wide" = annual_wide, "long" = annual_long)
write_xlsx(sheets, "AnnualInflowAll.xlsx")



