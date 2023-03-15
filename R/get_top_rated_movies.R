#' Get a list of the top 20 rated movies
#'
#' The list will contain top rated movies from all times.
#'
#' @export

get_top_rated_movies <- function() {
  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("/movie/top_rated") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb"))

  resp_req <- req %>%
    req_perform()

  resp_body_top_rated_movies <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()

  top_rated_movies <- resp_body_top_rated_movies %>%
    bind_cols(resp_body_top_rated_movies$results) %>%
    select(-(2:4)) %>%
    mutate(media_type = "movie") %>%
    relocate(id, title, genre_ids, .after = adult) %>%
    relocate(ends_with("path"), .after = last_col())

  return(top_rated_movies)
}
