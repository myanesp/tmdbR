#' Get a list of movies you can currently watch on cinemas
#'
#' Movies you can watch on cinemas right now.
#' 
#' @examples
#' get_in_cinemas()
#' @export

get_in_cinemas <- function(){
  
  req <- request(Sys.getenv("tmdb_endpoint")) %>% 
    req_url_path_append("/movie/now_playing") %>% 
    req_url_query(api_key = Sys.getenv("api_key_tmdb")) 
  
  resp_req <- req %>% 
    req_perform()
  
  resp_body_cinemas <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) 
  
  dates <- resp_body_cinemas$dates
  resp_body_cinemas <- resp_body_cinemas$results
  
  resp_body_cinemas <- resp_body_cinemas %>% 
    mutate(minimum = dates$minimum, maximum = dates$maximum) %>% 
    relocate(id, title, genre_ids, .after = adult) %>% 
    relocate(original_title, .after = overview) %>% 
    relocate(ends_with("path"), .after = last_col())
  
  return(resp_body_cinemas)
}