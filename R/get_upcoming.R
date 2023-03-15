#' Get a list of movies that are upcoming
#'
#' Movies that you will be able to watch in cinemas (or in your streaming
#' service) in the couple following weeks.
#' 
#' @examples
#' get_upcoming()
#' @export

get_upcoming <- function() {
  req <- request(Sys.getenv("tmdb_endpoint")) %>% 
    req_url_path_append("/movie/upcoming") %>% 
    req_url_query(api_key = Sys.getenv("api_key_tmdb")) 
  
  resp_req <- req %>% 
    req_perform()
  
  resp_body_upcoming <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) 
  
  dates <- resp_body_upcoming$dates
  resp_body_upcoming <- resp_body_upcoming$results
  
  resp_body_upcoming <- resp_body_upcoming %>% 
    mutate(minimum = dates$minimum, maximum = dates$maximum) %>% 
    relocate(id, title, genre_ids, .after = adult) %>% 
    relocate(original_title, .after = overview) %>% 
    relocate(ends_with("path"), .after = last_col())
  
  return(resp_body_upcoming)
}