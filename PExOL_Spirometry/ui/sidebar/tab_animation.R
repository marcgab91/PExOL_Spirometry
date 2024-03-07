tab_animation <-
  verticalTabPanel(
    title = h6("Animation"),
    box_height = "50px",
    fluidRow(
      column(10, style = "padding-left:15px;",
             h5("Animated trials:")
      ),
      column(2, style = "padding-top:7px;padding-right:32px;", align="right",
             circleButton("info_animation", "",
                          icon = icon("info"), status = "primary",
                          size = "xs", style="font-size:60%")
      )
    ),
    hidden(tags$div(id = "info_animation_div",
                    fluidRow(
                      column(12, style = "padding-left:15px;padding-right:32px;",
                             wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                       info_animation_text
                             )
                      )
                    )
    )),
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;",
             pickerInput("animated_trials", NULL,
                         choices = c(),
                         multiple = TRUE)
      )
    ),
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;", align="center",
             bsButton("animate_button", "Animate", style = "primary")
      )
    )
  )