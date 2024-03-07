# reads csv files that are separated by either comma or semicolon
readCSV <- function(path) {
  df <- read.csv(path, sep = ";", dec = ",")
  # if the df has only one column, the data is not semicolon separated
  if (ncol(df) == 1) {
    df <- read.csv(path, sep = ",", dec = ".")
  }
  return(df)
}