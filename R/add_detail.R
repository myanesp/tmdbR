#' Add media details to a given dataframe
#'
#' Request as many details as you want (revenue, cast, original language, ...)
#' from media and add them to an existing dataframe.
#'
#' @param origin Dataframe of origin
#' @param details The terms (quoted) that you are looking for
#' @export

add_detail <- function(origin, details) {

  for (d in details) {
    origin[[d]] <- NA
  }

  for (i in seq_len(nrow(origin))) {

    media_type <- origin[i, "media_type"]
    id <- origin[i, "id"]

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
            origin[i, d] <- paste0(resp_body_details[[d]][[1,1]], collapse = ", ")
          } else {
            origin[i, d] <- resp_body_details[[d]]
          }}
      } else {
        for (d in details) {
          origin[i, d] <- NA
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
            origin[i, d] <- paste0(resp_body_details[[d]][[1,1]], collapse = ", ")
          } else {
            origin[i, d] <- resp_body_details[[d]]
          }}
      } else {
        for (d in details) {
          origin[i, d] <- NA
        }
      }
    }
  }
  origin <- origin %>% relocate(ends_with("path"), .after = last_col())
  return(origin)
}
