library(rvest)
library(dplyr)
library(stringr)

fetch_billboard_hot100 <- function(chart_date = Sys.Date()) {
  # Billboard uses URLs like https://www.billboard.com/charts/hot-100/2024-03-23/
  url <- paste0("https://www.billboard.com/charts/hot-100/", chart_date, "/")
  
  page <- read_html(url)
  
  songs <- page |> html_nodes(".o-chart-results-list-row-container")
  
  tibble(
    rank = seq_along(songs),
    track = songs |> html_nodes(".o-chart-results-list__item h3") |> html_text(trim = TRUE),
    artist = songs |> html_nodes(".o-chart-results-list__item span") |> html_text(trim = TRUE),
    chart_date = as.Date(chart_date)
  )
}
