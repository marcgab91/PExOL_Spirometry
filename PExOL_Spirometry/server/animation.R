# Event: animate plot
observeEvent(input$animate_button, {
  req(nrow(reactive_plot_data$df) != 0 || nrow(reactive_man_data$df) != 0)
  req(isolate(input$animated_trials))
  
  # check data size
  size <- getPlotDatasize()
  if (size > 10000) {
    showSizeWarning()
  } else {
    loadAnimation()
  }
})

# displays a loading screen while rendering the animation
# afterwards displays the animation
loadAnimation <- function() {
  showLoadingScreen()
  doAnimate()
  removeModal()
  showAnimation()
}

# calculates and renders the animation
doAnimate <- function() {
  # generate the static plot
  gg <- generatePlot()
  # prepare the animated data
  df_animated <- createAnimatedData()
  parameters <- getPlotParameters()
  x_parameter <- parameters[1]
  y_parameter <- parameters[2]
  animation_data <- geom_point(data = df_animated, aes_string(x = x_parameter, y = y_parameter, group = "ID", colour = "DS_Name"), size = 4, shape = 19)

  # combine both
  gg_animation <- gg +
    animation_data +
    transition_reveal(Animated_Time) +
    shadow_wake(wake_length = 0.1)
  # determine duration
  duration <- round(max(df_animated$Animated_Time), 1)
  # animate and save
  anim_save("output/animation.gif", animate(gg_animation, duration = duration, fps = 20, width = 550, height = 400, renderer = magick_renderer()))
}

# displays the animation
showAnimation <- function() {
  showModal(modalDialog(
    # rendering gif
    renderImage({
      # display
      list(src = "output/animation.gif",
           contentType = 'image/gif'
      )
    }, deleteFile = FALSE),
    easyClose = FALSE,
    tags$style(
      HTML("
        .modal-content {
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }
        .modal-footer {
          text-align: center;
        }
      ")
    ),
    footer = tagList(
      actionButton("close_modal", "Close")
    )
  ))
}

# Close modal dialog
observeEvent(input$close_modal, {
  removeModal()
})

# creates the data that gets animated
createAnimatedData <- function() {
  df_combined <- isolate(rbind(reactive_plot_data$df, reactive_man_data$df))
  df_animated <- df_combined[df_combined$ID %in% input$animated_trials, ]
  df_animated$Animated_Time <- df_animated$Time
  return(df_animated)
}