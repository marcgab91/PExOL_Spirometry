# linear interpolates the point (x,y) between
# two given points (x1,y1) and (x2, y2)
# returns y
linearInterpolation <- function(x1, y1, x2, y2, x) {
  y <- y1 + (y2 - y1) * ((x - x1) / (x2 - x1))
  return(y)
}