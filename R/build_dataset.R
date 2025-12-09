library(dplyr)
library(purrr)
library(readr)
library(DBI)
library(RSQLite)

source("R/fetch_charts.R")
source("R/get_lyrics.R")
source("R/clean_lyrics.R")

build_dataset <- function() {

  chart <- fetch_billboard_hot100(Sys.Date())

  # Fetch lyrics
  lyric_data <- map2_dfr(chart$artist, chart$track, get_lyrics)

  # Clean + sentiment (bing only)
  scored <- clean_and_score_lyrics(lyric_data)

  # Ensure directories exist
  dir.create("data_raw", showWarnings = FALSE)
  dir.create("data_clean", showWarnings = FALSE)
  dir.create("data_db", showWarnings = FALSE)

  # Save CSV
  write_csv(lyric_data,          "data_raw/lyrics_raw.csv")
  write_csv(chart,               "data_raw/chart_raw.csv")
  write_csv(scored$tidy_words,   "data_clean/tidy_words.csv")
  write_csv(scored$sentiment,    "data_clean/sentiment.csv")

  # Save to SQLite (optional but still nice)
  con <- dbConnect(RSQLite::SQLite(), "data_db/lyrics.sqlite")
  dbWriteTable(con, "lyrics",     lyric_data,        overwrite = TRUE)
  dbWriteTable(con, "chart",      chart,             overwrite = TRUE)
  dbWriteTable(con, "tidy_words", scored$tidy_words, overwrite = TRUE)
  dbWriteTable(con, "sentiment",  scored$sentiment,  overwrite = TRUE)
  dbDisconnect(con)
}
