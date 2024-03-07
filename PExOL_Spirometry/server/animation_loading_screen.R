# displays a loading screen
showLoadingScreen <- function() {
  showModal(modalDialog(
    # loading screen
    HTML("<center><b>Rendering...</b></center>"),
    br(),
    tags$img(src = "loader.gif", height = "200px", width = "200px"),
    easyClose = FALSE,
    footer = NULL,
    tags$style(
      HTML("
        .modal-content {
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }
      ")
    )
  ))
}