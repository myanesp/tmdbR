#' Search for movies, TV shows or people
#'
#' Directly search for a given movie or a given actress from R and
#' obtain the basic information about it.
#'
#' @param query A string to search
#' @export

search_tmdb <- function(query) {

  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("/search/multi") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb")) %>%
    req_url_query(query = query) %>%
    req_url_query(lang = "language=en-US")

  resp_req <- req %>%
    req_perform()

  resp_body_req_search <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()

  search <- resp_body_req_search$results %>%
    mutate(mergetitle = coalesce(name, title),
           mergeoriginal = coalesce(original_name, original_title),
           premiere = coalesce(first_air_date, release_date)) %>%
    select(-title, -name, -original_name, -original_title) %>%
    rename(title = mergetitle, original_title = mergeoriginal) %>%
    relocate(ends_with("path"), .after = last_col()) %>%
    relocate(id, title, genre_ids, .after = adult) %>%
    relocate(original_title, .after = overview) %>%
    relocate("media_type", .after = title)

  return(search)
}
