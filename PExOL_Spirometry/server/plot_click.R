# plot clicked
observeEvent(input$plot_static_click, {
  click <- input$plot_static_click
  # determine plot type
  parameters <- getPlotParameters()
  x_parameter <- parameters[1]
  y_parameter <- parameters[2]
  # Get the index of the nearest point to click
  df_point <- nearPoints(reactive_man_data$df, click, xvar = x_parameter, yvar = y_parameter, threshold = 3, maxpoints = 1)
  if (nrow(df_point) != 0) {
    # update center point
    updateSliderInput(session, "man_center_point", value = df_point$Time[1])
  }
})
