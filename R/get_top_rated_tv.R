#' Get a list of the top 20 rated TV shows
#'
#' The list will contain top rated TV shows from all times.
#' 
#' @examples
#' get_top_rated_tv()
#' @export
#' 

get_top_rated_tv <- function() {
  req <- request(Sys.getenv("tmdb_endpoint")) %>% 
    req_url_path_append("/tv/top_rated") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb")) 
  
  resp_req <- req %>% 
    req_perform()
  
  resp_body_top_rated_tv <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()
  
  top_rated_tv <- resp_body_top_rated_tv %>% 
    bind_cols(resp_body_top_rated_tv$results) %>% 
    select(-(2:4)) %>% 
    mutate(media_type = "tv") %>%
    rename(title = name) %>% 
    relocate(id, title, genre_ids, .after = page) %>% 
    relocate(ends_with("path"), .after = last_col())
  
  return(top_rated_tv)
}