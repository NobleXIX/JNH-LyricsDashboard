library(dplyr)
library(purrr)
library(readr)

source("R/fetch_charts.R")
source("R/get_lyrics.R")
source("R/clean_lyrics.R")

build_dataset <- function() {

  chart <- fetch_billboard_hot100(Sys.Date())

  # Fetch lyrics for each (artist, track)
  lyric_data <- purrr::map2_dfr(chart$artist, chart$track, get_lyrics)

  # Clean + sentiment (bing only)
  scored <- clean_and_score_lyrics(lyric_data)

  # Ensure directories exist
  dir.create("data_raw", showWarnings = FALSE)
  dir.create("data_clean", showWarnings = FALSE)

  # Save CSVs (persistent storage = CSV, which meets the requirement)
  write_csv(lyric_data,        "data_raw/lyrics_raw.csv")
  write_csv(chart,             "data_raw/chart_raw.csv")
  write_csv(scored$tidy_words, "data_clean/tidy_words.csv")
  write_csv(scored$sentiment,  "data_clean/sentiment.csv")
}
