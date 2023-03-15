#' Transform genres ids into genres names.
#'
#' Add a column to the dataframe of your choice with the genres names and for 
#' not only having the IDs.
#' 
#' @examples
#' transform_genres(trending_week)
#' @export

transform_genres <- function(source) {
  genres_movies <- get_movie_genres()
  
  Sys.sleep(1)
  
  genres_tv <- get_tv_genres()
  
  if ("movie" %in% source$media_type){
    source <- source %>% 
      unnest(genre_ids) %>% 
      inner_join(genres_movies, by = c("genre_ids" = "id")) %>% 
      group_by(across(-c(genre_ids, name)), title) %>%   
      summarize(genres = paste(name, collapse = ", "), .groups = "drop") %>% 
      relocate(genres, .after = title) %>% 
      arrange(desc(vote_average))
    return(source)
  } else if ("tv" %in% source$media_type) {
    source <- source %>% 
      unnest(genre_ids) %>% 
      inner_join(genres_tv, by = c("genre_ids" = "id")) %>% 
      group_by(across(-c(genre_ids, name)), title) %>%   
      summarize(genres = paste(name, collapse = ", "), .groups = "drop") %>% 
      relocate(genres, .after = title) %>% 
      arrange(desc(vote_average))
    return(source)
  } else {
    stop("The media type is wrong.")
  }
}