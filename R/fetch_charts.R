library(readr)
library(dplyr)

# We'll use Spotify's Global daily chart CSV as our "chart" source
# This replaces the previous Billboard + rvest scraping.
fetch_billboard_hot100 <- function(chart_date = Sys.Date()) {
  # Spotify global daily latest chart as CSV
  url <- "https://spotifycharts.com/regional/global/daily/latest/download"
  
  # The CSV has a header row and then data starting on line 2, so we skip 1
  df <- readr::read_csv(url, skip = 1, show_col_types = FALSE)
  # Typical columns: Position, Track Name, Artist, Streams, URL
  
  df |>
    transmute(
      rank       = Position,
      track      = `Track Name`,
      artist     = Artist,
      streams    = Streams,
      chart_date = as.Date(chart_date)
    )
}
