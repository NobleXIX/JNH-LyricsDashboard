library(jsonlite)
library(dplyr)

get_lyrics <- function(artist, track) {
  artist_enc <- URLencode(artist)
  track_enc  <- URLencode(track)

  url <- paste0("https://api.lyrics.ovh/v1/", artist_enc, "/", track_enc)

  resp <- tryCatch(
    jsonlite::fromJSON(url),
    error = function(e) NULL
  )

  if (is.null(resp) || is.null(resp$lyrics)) {
    return(tibble(
      artist = artist,
      track  = track,
      lyrics = NA_character_
    ))
  }

  tibble(
    artist = artist,
    track  = track,
    lyrics = resp$lyrics
  )
}
