#' Add media details to a given dataframe
#'
#' Request as many details as you want (revenue, cast, original language, ...)
#' from media and add them to an existing dataframe.
#'
#' @param df Dataframe of origin
#' @param details The terms (quoted) that you are looking for
#' @examples
#' add_detail(df, c("revenue", "budget"))
#' @export

add_detail <- function(df, details) {
  df <- df
  for (d in details) {
    df[[d]] <- NA
  }

  for (i in seq_len(nrow(df))) {

    media_type <- df[i, "media_type"]
    id <- df[i, "id"]

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
            df[i, d] <- paste0(resp_body_details[[d]][[1,1]], collapse = ", ")
          } else {
            df[i, d] <- resp_body_details[[d]]
          }}
      } else {
        for (d in details) {
          df[i, d] <- NA
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
            df[i, d] <- paste0(resp_body_details[[d]][[1,1]], collapse = ", ")
          } else {
            df[i, d] <- resp_body_details[[d]]
          }}
      } else {
        for (d in details) {
          df[i, d] <- NA
        }
      }
    }
  }
  df <- df %>% relocate(ends_with("path"), .after = last_col())
  return(df)
}
