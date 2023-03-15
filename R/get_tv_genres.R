#' Get the list of the TV shows genres and their ids.
#'
#' A matrix equivalence of genres ids and genres names for TV shows.
#'
#' @export

get_tv_genres <- function(){
  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("/genre/tv/list") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb"))

  resp_req <- req %>%
    req_perform()

  resp_body_genres_tv <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()

  genres_tv <- resp_body_genres_tv %>%
    bind_cols(resp_body_genres_tv$genres) %>%
    select(id, name)

  return(genres_tv)
}
