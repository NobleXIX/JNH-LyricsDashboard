library(dplyr)
library(tidytext)
library(stringr)
library(tidyr)

clean_and_score_lyrics <- function(lyrics_df) {
  tidy <- lyrics_df |> 
    unnest_tokens(word, lyrics) |>
    anti_join(stop_words, by = "word") |>
    filter(!str_detect(word, "^[0-9]+$"))
  
  # Sentiment lexicons
  nrc <- get_sentiments("nrc")
  bing <- get_sentiments("bing")
  
  sentiment_scores <- tidy |>
    left_join(bing, by = "word") |>
    count(artist, track, sentiment) |>
    pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)
  
  emotion_scores <- tidy |>
    inner_join(nrc, by = "word") |>
    count(artist, track, sentiment) |>
    pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)
  
  list(
    tidy_words = tidy,
    sentiment = sentiment_scores,
    emotions = emotion_scores
  )
}
