get_genres_media <- function(id, type){
  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("/", type, "/") %>%
    req_url_path_append(id) %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb"))

  resp_req <- req %>%
    req_perform()

  resp_body_genres <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()

  genres <- resp_body_genres$results$genres_id
  if (length(streaming_providers) == 0) {
    streaming_providers <- NA
    return(paste("The genres of", title, "are", paste(genres, collapse = ", ")))
  } else {
    return(paste("The provided media has no genres assigned."))
  }
}
