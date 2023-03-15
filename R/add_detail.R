#' Add media details to a given dataframe
#'
#' Request as many details as you want (revenue, cast, original language, ...)
#' from media and add them to an existing dataframe.
#'
#' @param source Dataframe of origin
#' @param details The terms (quoted) that you are looking for
#' @examples
#' add_detail(trending_movies, c("revenue", "budget"))
#' @export

add_detail <- function(source, details) {
  
  for (d in details) {
    source[[d]] <- NA
  }
  
  for (i in seq_len(nrow(source))) {
    
    media_type <- source[i, "media_type"]
    id <- source[i, "id"]
    
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
      
      if (length(resp_body_details) > 0) {
        for (d in details) {
          if (is.data.frame(resp_body_details[[d]])) {
            source[i, d] <- paste0(resp_body_details[[d]][[1,1]], collapse = ", ")
          } else {
            source[i, d] <- resp_body_details[[d]]
          }}
      } else {
        for (d in details) {
          source[i, d] <- NA
        }
      }
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
      
      if (length(resp_body_details) > 0) {
        for (d in details) {
          if (is.data.frame(resp_body_details[[d]])) {
            source[i, d] <- paste0(resp_body_details[[d]][[1,1]], collapse = ", ")
          } else {
            source[i, d] <- resp_body_details[[d]]
          }}
      } else {
        for (d in details) {
          source[i, d] <- NA
        }
      }
    }
  }
  source <- source %>% relocate(ends_with("path"), .after = last_col())
  return(source)  
}