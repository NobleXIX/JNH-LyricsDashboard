library(readr)
library(dplyr)

# Use Spotify's global daily chart CSV as the "chart" source
fetch_billboard_hot100 <- function(chart_date = Sys.Date()) {
  url <- "https://spotifycharts.com/regional/global/daily/latest/download"
  
  # Skip the first line of description, then read the CSV
  df <- readr::read_csv(url, skip = 1, show_col_types = FALSE)
  # We expect: column 1 = position, 2 = track name, 3 = artist, 4 = streams
  
  # Just use the first 4 columns by index, regardless of their names
  df <- df |> dplyr::select(1:4)
  
  tibble::tibble(
    rank       = df[[1]],
    track      = df[[2]],
    artist     = df[[3]],
    streams    = df[[4]],
    chart_date = as.Date(chart_date)
  )
}
