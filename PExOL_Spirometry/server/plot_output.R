# static plot output
output$plot_static <- renderPlot({
  gg <- generatePlot()
  gg
})

# generates the plot and returns a ggplot object
generatePlot <- function() {
  # change plot parameters depending on plot type
  parameters <- getPlotParameters()
  x_parameter <- parameters[1]
  y_parameter <- parameters[2]
  labels <- getPlotLabels()
  x_label <- labels[1]
  y_label <- labels[2]
  # show all ref data as background
  all_ref_data <- NULL
  if (input$ref_data_background_switch == TRUE) {
    all_ref_data <- geom_path(data = df_ref_data_raw, aes_string(x = x_parameter, y = y_parameter, group = "ID"), color = "grey85", linewidth = 0.5)
  }
  
  # show characteristic points
  char_data <- NULL
  if (nrow(reactive_char_data$plot) != 0) {
    char_data <- geom_point(data = reactive_char_data$plot, aes_string(x = x_parameter, y = y_parameter, group = "ID", colour = "DS_Name"), size = 3.5, shape = 19)
  }
  
  # show manipulation zone points
  man_zone_data <- NULL
  if (input$man_zone_switch == TRUE) {
    if (nrow(reactive_man_data$area) != 0) {
      man_zone_data <- geom_point(data = reactive_man_data$area, aes_string(x = x_parameter, y = y_parameter, group = "ID"), colour = "black", size = c(6, 7, 6), shape = c(124, 3, 124))
    }
  }
  
  # prepare plot data
  man_data <- NULL
  if (nrow(reactive_man_data$df) != 0) {
    man_data <- reactive_man_data$df
    man_data$ID <- "y_man_data_0"
  }
  man_data_temp <- NULL
  if (nrow(reactive_man_data$temp) != 0) {
    man_data_temp <- reactive_man_data$temp
    man_data_temp$ID <- "x_man_data_0_temp"
  }
  plot_data <- rbind(reactive_plot_data$df, man_data_temp, man_data)
  
  # plotting
  gg <- ggplot(plot_data, aes_string(x = x_parameter, y = y_parameter, group = "ID", colour = "DS_Name")) +
    all_ref_data +
    geom_path(linewidth = 0.9) +
    char_data +
    man_zone_data +
    xlab(x_label) +
    ylab(y_label) +
    scale_colour_manual(values = c("User data"= "steelblue3",
                                   "Reference data" = "purple3",
                                   "Manipulated data" = "red3",
                                   "Manipulated temp data" = "#ffb09c")) +
    theme_classic() +
    theme(legend.title = element_blank(),
          legend.position = "none",
          axis.title.x = element_text(color="black", size=14),
          axis.title.y = element_text(color="black", size=14),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12),
          panel.grid.major = element_line(colour = "grey93", linetype = "solid"),
          panel.grid.minor = element_line(colour = "grey93", linetype = "dashed")
    )
  
  # return the ggplot object
  return(gg)
}