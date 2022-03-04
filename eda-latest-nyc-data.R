library(dplyr)

prep_data <- function(
  file = here::here("data/nyc_daily_pm2.5_components.csv"), 
  years = c(as.Date("2007-01-01"), as.Date("2016-01-01")),
  exclude = c("cobalt", "antimony"),
  title = "NYC") 
{
  data <- readr::read_csv(file) %>% 
          filter(Date >= years[1], Date < years[2]) %>% 
          select(!all_of(exclude))
  
  data.mat <- data %>% select(!Date)
  data.mat[data.mat < 0] <- 0
  data.mat.scaled <- scale(data.mat, center = FALSE)
  
  title <- paste0(title, ": ", format.Date(years[1], "%Y"), " - ", format.Date(years[2], "%Y"))
  
  list(M = data.mat, M.scaled = data.mat.scaled, M.dates = data$Date, M.title = title)
}


