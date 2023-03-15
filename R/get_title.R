#' Get the title by ID
#'
#' Obtain the title for your movie or tv show of preferrance by searching
#' by id.
#' @param id ID of the media
#' @param type Whether is a "movie" or a "tv" show.
#' @export


get_title <- function(id, type) {
  details <- get_details(id, type)
  title <- details$title
  return(title)
}
