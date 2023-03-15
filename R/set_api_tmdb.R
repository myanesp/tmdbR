#' Set your TMDB API from a .txt file
#'
#' Store your TMDB API as an environmental variable to start. The function
#' will validate your API against TMDB servers, and check if it is right.
#'
#' @param file_path The path to your .txt file where is stored the API
#' @export

set_api_tmdb <- function(file_path) {
  Sys.setenv(tmdb_endpoint = "https://api.themoviedb.org/3")
  if (!grepl("\\.txt$", file_path)) {
    stop("File must be a .txt")
  }

  api_key <- read_file(file_path)

  if (length(api_key) != 1 || nchar(api_key) != 32) {
    stop("API key must be a 32 character string. Check your file and correct it.")
  }
  req <- request(Sys.getenv("tmdb_endpoint")) %>%
    req_url_path_append("configuration") %>%
    req_url_query(api_key = api_key)

  resp_req <- req %>%
    req_perform()

  if (resp_req$status_code == 200) {
    message("Your API key is valid. It has been succesfully stored.")
    Sys.setenv(api_key_tmdb = api_key)
  } else {
    message("There was an error with your API key.")
  }
}
