library(dplyr)
library(tidytext)
library(stringr)
library(tidyr)

clean_and_score_lyrics <- function(lyrics_df) {
  # Safety check
  if (!"lyrics" %in% names(lyrics_df)) {
    stop("clean_and_score_lyrics(): column 'lyrics' not found in lyrics_df", call. = FALSE)
  }
  
  # Only keep rows with lyrics
  lyrics_df <- lyrics_df |> filter(!is.na(lyrics))

  # Tokenize words from lyrics
  tidy <- lyrics_df |>
    unnest_tokens(word, lyrics) |>
    anti_join(stop_words, by = "word") |>
    filter(!str_detect(word, "^[0-9]+$"))  # drop pure numbers
  
  # Use only the bing sentiment lexicon (no NRC, no textdata)
  bing <- get_sentiments("bing")
  
  sentiment_scores <- tidy |>
    inner_join(bing, by = "word", multiple = "all") |>
    count(artist, track, sentiment, name = "n") |>
    pivot_wider(
      names_from  = sentiment,
      values_from = n,
      values_fill = 0
    )

  list(
    tidy_words = tidy,
    sentiment  = sentiment_scores
  )
}
