library(jsonlite)
library(dplyr)

fetch_billboard_hot100 <- function(chart_date = Sys.Date()) {
  url <- "https://itunes.apple.com/us/rss/topsongs/limit=50/json"
  
  json <- jsonlite::fromJSON(url, flatten = TRUE)
  entries <- json$feed$entry
  
  if (is.null(entries) || nrow(entries) == 0) {
    stop("iTunes top songs feed returned no entries. Check the source format or URL.")
  }
  
  if (ncol(entries) < 2) {
    stop("iTunes top songs feed did not return at least 2 columns.")
  }
  
  tibble::tibble(
    rank       = seq_len(nrow(entries)),
    track      = as.character(entries[[1]]),
    artist     = as.character(entries[[2]]),
    streams    = NA_integer_,
    chart_date = as.Date(chart_date)
  )
}
