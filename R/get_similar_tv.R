#' Get a list of similar TV shows from a reference one
#'
#' A data frame with all the similar TV shows from the TV show you want.
#'
#' @param id The id of the TV show
#' @export

get_similar_tv <- function(id) {
  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("tv") %>%
    req_url_path_append(id) %>%
    req_url_path_append("similar") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb"))

  resp_req <- req %>%
    req_perform()

  resp_body_similar <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE)

  title_from <- get_details(id, "tv", "name")

  similar <- resp_body_similar$results %>%
    mutate(id_from = title_from$id,
           title_from = title_from$title)

  return(similar)
}
