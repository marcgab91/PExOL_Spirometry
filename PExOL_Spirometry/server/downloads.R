# Download the data of the manipulated trial
output$download_manipulated_trial <- downloadHandler(
  filename = function() {"manipulated_data.csv"},
  content = function(file) {
    write.csv(reactive_man_data$df[, c("Time", "Volume", "Flow")], file, row.names = FALSE)
  }
)

# Download current plot as png
output$download_plot_png <- downloadHandler(
  filename = function() {"plot.png"},
  content = function(file) {
    ggsave(file, plot = generatePlot(),
           width = 2200, height = 1600,
           units = "px", device = "png")
  }
)

# Download last animation as gif
output$download_plot_gif <- downloadHandler(
  filename = function() {"animation.gif"},
  content = function(file) {
    file.copy("output/animation.gif", file)
  }
)