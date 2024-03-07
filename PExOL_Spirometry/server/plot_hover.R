## Tooltip for hover-event on plot
output$hover_info <- renderUI({
  df_man <- reactive_man_data$df
  df_plot <- reactive_plot_data$df
  hover <- input$plot_static_hover
  # determine plot type
  parameters <- getPlotParameters()
  x_parameter <- parameters[1]
  y_parameter <- parameters[2]
  # Get the nearest point to hover (first look in manipulated data, then in other plot data)
  df_point <- nearPoints(df_man, hover, xvar = x_parameter, yvar = y_parameter, threshold = 3, maxpoints = 1)
  if (nrow(df_point) == 0) {
    df_point <- nearPoints(df_plot, hover, xvar = x_parameter, yvar = y_parameter, threshold = 3, maxpoints = 1)
  }
  # display
  displayTooltip(hover, df_point)
})

## Tooltip display by hovering over data point
displayTooltip <- function(hover, df_point) {
  # No point near enough
  if (nrow(df_point) == 0) return(NULL)
  # Get mouse position
  x_px <- hover$coords_css$x
  y_px <- hover$coords_css$y
  # background color
  b_color <- NULL
  switch(
    df_point$DS_Name[1],
    "User data" = {
      b_color <- 	"	rgba(79,148,205,0.75)"
    },
    "Reference data" = {
      b_color <- "rgba(125,38,205,0.75)"
    },
    "Manipulated data" = {
      b_color <- "rgba(205,0,0,0.75)"
    }
  )
  # Create and display tooltip
  wellPanel(
    style = paste0("position:absolute; z-index:100; background-color: ", b_color, "; padding: 9px 13px 0px 13px; ",
                   "left:", x_px + 20, "px; top:", y_px + 50, "px;"),
    p(HTML(paste0("<font color='#FFFFFF'><b>", df_point$DS_Name[1], "</b><br/>",
                  "<b>ID:&nbsp</b>", df_point$DS_Trial_ID[1], "<br/>",
                  "<b>Time:&nbsp</b>", df_point$Time[1], "<br/>",
                  "<b>Volume:&nbsp</b>", df_point$Volume[1], "<br/>",
                  "<b>Flow:&nbsp</b>", df_point$Flow[1], "</font>"
    )))
  )
}