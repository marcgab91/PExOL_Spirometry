tab_overview <-
  verticalTabPanel(
    title = h6("Overview"),
    box_height = "50px",
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;",
             overview_text
      )
    )
  )

  