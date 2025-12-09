library(readr)
library(dplyr)

# Use Spotify's global daily chart CSV as the "chart" source
fetch_billboard_hot100 <- function(chart_date = Sys.Date()) {
  url <- "https://spotifycharts.com/regional/global/daily/latest/download"
  
  # The file is semicolon-separated (;) so we use read_csv2()
  # Skip the first line (description), then read the data
  df <- readr::read_csv2(url, skip = 1, show_col_types = FALSE)
  # Expected columns (or similar): Position, Track Name, Artist, Streams, URL
  
  # If the structure isn't what we expect, fail loudly
  if (ncol(df) < 4) {
    stop("Spotify chart download did not return at least 4 columns. Check the source format.")
  }
  
  tibble::tibble(
    rank       = df[[1]],  # position
    track      = df[[2]],  # track name
    artist     = df[[3]],  # artist
    streams    = df[[4]],  # streams
    chart_date = as.Date(chart_date)
  )
}
