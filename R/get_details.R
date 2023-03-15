#' Get media details for a movie or TV show
#'
#' Request as many details as you want (revenue, cast, original language, ...)
#' from media and print them.
#'
#' @param id ID of the movie/TV show
#' @param type If it is a "movie" or a "tv" show.
#' @param details The details you are looking for.
#' @examples
#' get_details(238, "movie", c("revenue", "budget"))
#' @export

get_details <- function(id, type, details = NULL) {
  
  media_type <- type
  
  if (media_type == "movie") {
    req <- request(Sys.getenv("tmdb_endpoint")) %>% 
      req_url_path_append("movie") %>%
      req_url_path_append(id) %>% 
      req_url_query(api_key = Sys.getenv("api_key_tmdb"))
    
    resp_req <- req %>% 
      req_perform()
    
    resp_body_details <-
      resp_req %>%
      resp_body_json(simplifyVector = TRUE)
    
    title <- resp_body_details$title
    id <- resp_body_details$id
    detail_values <- resp_body_details[details]
    
    details_df <- data.frame(title, id, detail_values)
    
    return(details_df)
  } else if (media_type == "tv") {
    
    req <- request(Sys.getenv("tmdb_endpoint")) %>% 
      req_url_path_append("tv") %>%
      req_url_path_append(id) %>% 
      req_url_query(api_key = Sys.getenv("api_key_tmdb"))
    
    resp_req <- req %>% 
      req_perform()
    
    resp_body_details <-
      resp_req %>%
      resp_body_json(simplifyVector = TRUE)
    
    title <- resp_body_details$name
    id <- resp_body_details$id
    detail_values <- resp_body_details[details]
    
    details_df <- data.frame(title, id, detail_values)
    
    return(details_df)
    
  } else {
    stop("You haven't specified a media type or your ID is not found. Please check.")
  }
}