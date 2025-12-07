library(httr2)
library(jsonlite)
library(dplyr)

get_lyrics <- function(artist, track) {
  artist_enc <- URLencode(artist)
  track_enc  <- URLencode(track)
  
  url <- paste0("https://api.lyrics.ovh/v1/", artist_enc, "/", track_enc)
  
  resp <- request(url) |> req_perform()
  
  if (resp$status_code != 200) {
    return(tibble(artist, track, lyrics = NA))
  }
  
  json <- resp |> resp_body_json()
  
  tibble(
    artist = artist,
    track = track,
    lyrics = json$lyrics
  )
}
