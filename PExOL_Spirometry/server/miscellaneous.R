# returns the number of decimal places
getDecimalPlaces <- function(number) {
  dec <- nchar(sub(".*\\.", "", as.character(number)))
  return(dec)
}