# returns the current plot parameters as string vector
getPlotParameters <- function() {
  x_parameter <- NULL
  y_parameter <- NULL
  switch(
    input$plot_type,
    "volume_time" = {
      x_parameter <- "Time"
      y_parameter <- "Volume"
    },
    "flow_volume" = {
      x_parameter <- "Volume"
      y_parameter <- "Flow"
    },
    "flow_time" = {
      x_parameter <- "Time"
      y_parameter <- "Flow"
    }
  )
  return(c(x_parameter, y_parameter))
}

# returns the current plot labels as string vector
getPlotLabels <- function() {
  x_label <- NULL
  y_label <- NULL
  switch(
    input$plot_type,
    "volume_time" = {
      x_label <- "Time [s]"
      y_label <- "Volume [l]"
    },
    "flow_volume" = {
      x_label <- "Volume [l]"
      y_label <- "Flow [l/s]"
    },
    "flow_time" = {
      x_label <- "Time [s]"
      y_label <- "Flow [l/s]"
    }
  )
  return(c(x_label, y_label))
}