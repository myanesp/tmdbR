.onAttach <- function(libname, pkgname) {
  message <- c("\n Thanks for using the tmdbR package!",
               "\n \n This is an alpha version of the package, which was created for educational purposes.",
               "\n While we try to do our best, tricky things may happen :) We will continue improving the package.")
  packageStartupMessage(message)
}