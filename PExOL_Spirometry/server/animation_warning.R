# returns the number of data entries that get plotted
getPlotDatasize <- function() {
  n1 <- 0
  if (input$ref_data_background_switch == TRUE) {
    n1 <- nrow(df_ref_data_raw)
  }
  n2 <- nrow(reactive_char_data$plot)
  n3 <- nrow(reactive_plot_data$df)
  n4 <- nrow(createAnimatedData())
  n <- n1 + n2 + n3 + n4
  return(n)
}

# shows a warning message because of large plot data
showSizeWarning <- function() {
  showModal(modalDialog(
    # warning message
    HTML("<center><b>Rendering an animation with large amounts of data can take several minutes.<br>
         Do you wish to continue?</b></center>"),
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
      bsButton("continue_modal", "Continue", style = "primary"),
      actionButton("cancel_modal", "Cancel")
    )
  ))
}

# Cancel modal dialog
observeEvent(input$cancel_modal, {
  removeModal()
})

# Continue to animation
observeEvent(input$continue_modal, {
  removeModal()
  loadAnimation()
})