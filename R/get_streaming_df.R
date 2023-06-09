#' Add the streaming providers for media in an existing dataframe
#'
#' If you have a cool dataframe with information about movies and TV shows,
#' complement it with the place where you can watch them (currently,
#' for USA and Spain). Through JustWatch.
#'
#' @param df Dataframe of origin
#' @export

get_streaming_df <- function(df) {

  df <- df %>%
    mutate(streaming_es = NA, streaming_us = NA)

  for (i in seq_len(nrow(df))) {

    media_type <- df[i, "media_type"]
    id <- df[i, "id"]

    if (media_type == "movie") {

      req <- request(Sys.getenv("tmdb_endpoint")) %>%
        req_url_path_append("movie") %>%
        req_url_path_append(id) %>%
        req_url_path_append("/watch/providers") %>%
        req_url_query(api_key = Sys.getenv("api_key_tmdb"))

      Sys.sleep(1)

      resp_req <- req %>%
        req_perform()

      resp_body_streaming <- resp_req %>%
        resp_body_json(simplifyVector = TRUE) %>%
        as_tibble()

      streaming_providers_es <- resp_body_streaming$results$ES$flatrate$provider_name
      streaming_providers_us <- resp_body_streaming$results$US$flatrate$provider_name

      if (length(streaming_providers_us) > 0) {
        df[i, "streaming_us"] <- paste(streaming_providers_us, collapse = ", ")
      } else {
        df[i, "streaming_us"] <- "NA"
      }

      if (length(streaming_providers_es) > 0) {
        df[i, "streaming_es"] <- paste(streaming_providers_es, collapse = ", ")
      } else {
        df[i, "streaming_es"] <- "NA"
      }

    } else if (media_type == "tv") {

      req <- request(Sys.getenv("tmdb_endpoint")) %>%
        req_url_path_append("tv") %>%
        req_url_path_append(id) %>%
        req_url_path_append("/watch/providers") %>%
        req_url_query(api_key = Sys.getenv("api_key_tmdb"))

      Sys.sleep(5)

      resp_req <- req %>%
        req_perform()

      resp_body_streaming <- resp_req %>%
        resp_body_json(simplifyVector = TRUE) %>%
        as_tibble()

      streaming_providers_es <- resp_body_streaming$results$ES$flatrate$provider_name
      streaming_providers_us <- resp_body_streaming$results$US$flatrate$provider_name

      if (length(streaming_providers_us) > 0) {
        df[i, "streaming_us"] <- paste(streaming_providers_us, collapse = ", ")
      } else {
        df[i, "streaming_us"] <- "NA"
      }

      if (length(streaming_providers_es) > 0) {
        df[i, "streaming_es"] <- paste(streaming_providers_es, collapse = ", ")
      } else {
        df[i, "streaming_es"] <- "NA"
      }

    } else {

      stop("Invalid type. It must be 'tv' or 'movie'.")

    }

  }

  return(df)
}
