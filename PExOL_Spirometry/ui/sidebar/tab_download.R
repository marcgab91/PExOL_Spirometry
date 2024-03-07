tab_download <-
  verticalTabPanel(
    title = h6("Download"),
    box_height = "50px",
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;", align="center",
             br(),
             downloadButton("download_manipulated_trial", "Manipulated trial",
                            style = "width: 75%;")
      )
    ),
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;", align="center",
             br(),
             downloadButton("download_plot_png", "Plot PNG",
                            style = "width: 75%;")
      )
    ),
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;", align="center",
             br(),
             downloadButton("download_plot_gif", "Plot GIF",
                            style = "width: 75%;")
      )
    )
  )