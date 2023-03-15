#' Get a list of the week trending media
#'
#' Movies and TV shows that are trending the last 7 days
#'
#' @export

get_trending_week <- function() {

  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("/trending/all/week") %>%
    req_url_query(api_key = Sys.getenv("api_key_tmdb"))

  resp_req <- req %>%
    req_perform()

  resp_body_req_week <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()

  trending_week <- resp_body_req_week %>%
    bind_cols(resp_body_req_week$results) %>%
    select(-(2:4)) %>%
    mutate(mergetitle = coalesce(name, title),
           mergeoriginal = coalesce(original_name, original_title),
           premiere = coalesce(first_air_date, release_date)) %>%
    select(-name, -title, -original_name, -original_title, -release_date, -first_air_date) %>%
    rename(title = mergetitle, original_title = mergeoriginal) %>%
    relocate(id, title, genre_ids, .after = page) %>%
    relocate(original_title, .after = overview) %>%
    relocate(ends_with("path"), .after = last_col())

  return(trending_week)
}
