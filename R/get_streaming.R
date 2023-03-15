#' Get the streaming provider for a movie or TV show
#'
#' If you have a dataframe with all movies or all TV show, you can extract
#' the information with this function. Please, be advised that will be deprecated.
#'
#' @param df Dataframe of origin
#' @param type Whether is a "tv" show or a "movie".
#' @examples
#' get_streaming(top_tv, "tv")
#' @export

get_streaming <- function(df, type){
  df <- df %>%
    mutate(streaming_es = NA, streaming_us = NA)
  if (type %in% c("tv", "movie")) {
    for (i in df$id) {
      idx <- which(df$id == i)
      req <- request(Sys.getenv("tmdb_endpoint")) %>%
        req_url_path_append(type) %>%
        req_url_path_append(i) %>%
        req_url_path_append("/watch/providers") %>%
        req_url_query(api_key = Sys.getenv("api_key_tmdb"))

      Sys.sleep(1)

      resp_req <- req %>%
        req_perform()

      resp_body_streaming <-
        resp_req %>%
        resp_body_json(simplifyVector = TRUE) %>%
        as_tibble()

      streaming_providers_es <- resp_body_streaming$results$ES$flatrate$provider_name
      streaming_providers_us <- resp_body_streaming$results$US$flatrate$provider_name

      if (length(streaming_providers_us) > 0) {
        df$streaming_us[idx] <- paste(streaming_providers_us, collapse = ", ")
      } else {
        df$streaming_us[idx] <- "NA"
      }
      if (length(streaming_providers_es) > 0) {
        df$streaming_es[idx] <- paste(streaming_providers_es, collapse = ", ")
      } else {
        df$streaming_es[idx] <- "NA"
      }
    }
    df <- df %>%
      relocate(ends_with("path"), .after = last_col())
    return(df)
  } else {
    stop("Invalid type. It must be 'tv' or 'movie'.")
  }
}
