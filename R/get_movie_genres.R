#' Get the list of movies genres and their ids.
#'
#' A matrix equivalence of genres ids and genres names for movies.
#' 
#' @examples
#' get_movie_genres()
#' @export


get_movie_genres <- function(){
  req <- request(Sys.getenv("tmdb_endpoint")) %>% 
    req_url_path_append("/genre/movie/list") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb"))
  
  resp_req <- req %>% 
    req_perform()
  
  resp_body_genres_movies <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()
  
  genres_movies <- resp_body_genres_movies %>% 
    bind_cols(resp_body_genres_movies$genres) %>% 
    select(id, name)
  
  return(genres_movies)
}