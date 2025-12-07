library(fmsb)

plot_radar <- function(emotion_row) {
  emotions <- emotion_row |> select(-artist, -track)
  maxes <- rep(max(emotions), ncol(emotions))
  mins  <- rep(0, ncol(emotions))
  df <- rbind(maxes, mins, emotions)
  radarchart(df)
}

plot_sentiment <- function(sent_df) {
  sent_df |>
    pivot_longer(cols = -c(artist, track), names_to = "sentiment") |>
    ggplot(aes(sentiment, value, fill = sentiment)) +
    geom_col() +
    theme_minimal() +
    labs(title = "Sentiment Score", y = "Count")
}

plot_wordfreq <- function(tidy_words, artist, track) {
  tidy_words |>
    filter(artist == artist, track == track) |>
    count(word, sort = TRUE) |>
    head(20) |>
    ggplot(aes(x = reorder(word, n), y = n)) +
    geom_col() +
    coord_flip() +
    labs(title = paste("Top Words in", track), x = "Word", y = "Frequency")
}
