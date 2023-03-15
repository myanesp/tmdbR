#' Get the streaming provider for a given media
#'
#' Catch the id of the media you want to watch and in which country,
#' and this function will return the information
#'
#' @param id ID of the media
#' @param type Whether is a "tv" show or a "movie".
#' @param country [ISO 3166 code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
#' @export

get_streaming_providers <- function(id, type, country) {

  if (type %in% c("tv", "movie")) {
    req <- request(Sys.getenv("tmdb_endpoint")) %>%
      req_url_path_append(type) %>%
      req_url_path_append(id) %>%
      req_url_path_append("watch/providers") %>%
      req_url_query(api_key = Sys.getenv("api_key_tmdb"))

    resp_req <- req %>%
      req_perform()

    resp_body_streaming <-
      resp_req %>%
      resp_body_json(simplifyVector = TRUE) %>%
      as_tibble()

    streaming_providers <- resp_body_streaming$results[[country]]$flatrate$provider_name
    if (length(streaming_providers) == 0) {
      streaming_providers <- NA
      if (type == "movie") {
        return("The provided movie is not available on the country you have selected.")
      } else if (type == "tv"){
        return("The provided TV show is not available on the country you have selected.")
      }
    } else {
      if (type == "movie"){
        return(paste("You can watch the requested movie in", country, "on", paste(streaming_providers, collapse = ", ")))
      } else if (type == "tv") {
        return(paste("You can watch the requested TV show in ", country, "on", paste(streaming_providers, collapse = ", ")))
      }
    }
  }
}
