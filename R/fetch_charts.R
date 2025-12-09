library(jsonlite)
library(dplyr)

# Use Apple iTunes Top Songs RSS (JSON) as "chart" source
fetch_billboard_hot100 <- function(chart_date = Sys.Date()) {
  url <- "https://itunes.apple.com/us/rss/topsongs/limit=50/json"
  
  # Get and flatten JSON
  json <- jsonlite::fromJSON(url, flatten = TRUE)
  entries <- json$feed$entry
  
  if (is.null(entries) || nrow(entries) == 0) {
    stop("iTunes top songs feed returned no entries. Check the source format or URL.")
  }
  
  cols <- names(entries)
  
  # Try to find appropriate columns for track + artist
  track_col <- dplyr::case_when(
    "im.name.label" %in% cols   ~ "im.name.label",
    "title.label"   %in% cols   ~ "title.label",
    TRUE                        ~ NA_character_
  )
  
  artist_col <- dplyr::case_when(
    "im.artist.label" %in% cols ~ "im.artist.label",
    "artist.label"    %in% cols ~ "artist.label",
    TRUE                        ~ NA_character_
  )
  
  if (is.na(track_col) || is.na(artist_col)) {
    stop("Unexpected iTunes JSON structure: could not find track or artist columns.")
  }
  
  tibble::tibble(
    rank       = seq_len(nrow(entries)),
    track      = entries[[track_col]],
    artist     = entries[[artist_col]],
    streams    = NA_integer_,  # we don't have streams here, just rank
    chart_date = as.Date(chart_date)
  )
}
