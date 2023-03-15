# `tmdbR`: a package to interact and obtain data from The Movie DB using its API from R
<!-- badges: start -->
[![R-CMD-check](https://github.com/myanesp/tmdbR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/myanesp/tmdbR/actions/workflows/R-CMD-check.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/myanesp/tmdbR/badge)](https://www.codefactor.io/repository/github/myanesp/tmdbR)
[![](https://img.shields.io/github/languages/code-size/myanesp/tmdbR.svg)](https://github.com/myanesp/tmdbR)
<!-- badges: end -->

## What does this package do?
This package allows you to easily interact and obtain data from TMDB, through its API (you must have one!), directly from R. 
Also, it has custom functions that allows you to transform the data you obtain, making it more powerful and descriptive.
Nonetheless, please be aware that the package is in an alpha stages so not all the features are available and some bugs may appear.

All the functions are made following strictly the [reference of the API](https://developers.themoviedb.org/3/), and any term a function may need 
has to be equal to the terms on that page.

## Features
- Ability to get the list of the top 20 of: top rated movies/TV shows, trending movies/TV shows, daily and weekly trending media, etc.
- Ability to get details from your media flexibly: whatever you want, you have it!
- Ability to obtain the streaming service providers where the media can be watched (thanks to JustWatch and its partnertship with TMDB).
- Ability to convert the genres id's into real genres. Who wants to know that 'The Godfather' is genre 18, when we know it's a drama!
- Ability to search for movies, TV shows or people directly from your console. 
- Other information like similar movies, information about companies, cast, what's next...

## Installation
```r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("myanesp/tmdbR")
# And then load into your current session
library(tmdbR)
```

## Usage
You have to register for an account on the [TMDB website](https://www.themoviedb.org/signup), and then request your [personal API](https://www.themoviedb.org/settings/api).

Once you have your API token, that is your magic key in order to tinker with TMDB from R, you have to stored it in a `.txt`. Then, load it into your session by calling `set_api_tmdb("your_file.txt")`, and you are ready to go!

As we strictly follow the parameters proposed by TMDB, take a look at [its documentation page](https://developers.themoviedb.org/3/) to be familiar with the terms.

## Examples
``` r
get_trending_movies() # returns a list of the top 20 trending movies
search_tmdb("friends") # returns results that matches your search.
transform_genres(trending_movies) # adds a new column called "genres" that has the name of the genres, instead of only having their id's.
get_streaming_providers(238, "movie", "ES") # returns a list of available suscriptions platforms in Spain where you can watch The Godfather.
```
## Roadmap

## Final notes
This project is not endorsed, related or funded by TMDB nor JustWatch.
