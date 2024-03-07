tab_manipulation <-
  verticalTabPanel(
    title = h6("Manipulation"),
    box_height = "50px",
    
    fluidRow(
      column(10, style = "padding-left:15px;",
             h5("Starting trial:")
      ),
      column(2, style = "padding-top:7px;padding-right:32px;", align="right",
             circleButton("info_starting_trial", "",
                          icon = icon("info"), status = "primary",
                          size = "xs", style="font-size:60%")
      )
    ),
    hidden(tags$div(id = "info_starting_trial_div",
                    fluidRow(
                      column(12, style = "padding-left:15px;padding-right:32px;",
                             wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                       info_starting_trial_text
                             )
                      )
                    )
    )),
    fluidRow(
      column(8, style = "padding-left:15px;",
             selectInput("starting_trial", NULL,
                         choices = c())
      ),
      column(4, style = "padding-left:15px;",
             bsButton("create_manipulated_trial", "New", style = "primary"),
             hidden(bsButton("reset_manipulated_trial", "Reset", style = "primary"))
      )
    ),
    br(),
    hidden(tags$div(id = "man_div",
             fluidRow(
               column(5, style = "padding-top:5px;padding-left:15px;padding-right:0px;",
                      h5("Show zone")
               ),
               column(3, style = "padding-top:13px;padding-right:0px;",
                      materialSwitch("man_zone_switch", NULL, 
                                     value = TRUE, status = "primary")
               ),
               column(4, style = "padding-top:10px;padding-right:32px;", align="right",
                      circleButton("info_zone", "",
                                   icon = icon("info"), status = "primary",
                                   size = "xs", style="font-size:60%")
               )
             ),
             hidden(tags$div(id = "info_zone_div",
                             fluidRow(
                               column(12, style = "padding-left:15px;padding-right:32px;",
                                      wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                                info_zone_text
                                      )
                               )
                             )
             )),
             fluidRow(
               column(5, style = "padding-top:15px;padding-left:15px;padding-right:0px;",
                      h5("Center point [Time]")
               ),
               column(7, style = "padding-top:15px;padding-right:32px;",
                      sliderInput("man_center_point", label = NULL,
                                   value = 1, min = 1, max = 1, step = 0.01)
               ),
             ),
             fluidRow(
               column(5, style = "padding-top:15px;padding-left:15px;padding-right:0px;",
                      h5("Range [Time]")
               ),
               column(7, style = "padding-top:15px;padding-right:32px;",
                      sliderInput("man_range", label = NULL,
                                   value = 1, min = 1, max = 1, step = 0.01)
               ),
             ),
             fluidRow(
               column(12, style = "padding-left:15px;padding-right:32px;",
                      radioGroupButtons("man_para", NULL,
                                        choices = c("Time", "Volume", "Flow"), justified = TRUE, status = "primary",
                                        checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon")),
                                        selected = c("Time"))
               )
             ),
             tags$div(id = "man_time_div",
                      fluidRow(
                        column(10, style = "padding-left:15px;padding-right:10px;",
                               sliderInput("man_range_time", label = NULL, width = "100%",
                                           value = 1, min = 0.1, max = 10, step = 0.01)
                        ),
                        column(2, style = "padding-right:32px;", align="right",
                               circleButton("info_man_time", "",
                                            icon = icon("info"), status = "primary",
                                            size = "xs", style="font-size:60%")
                        )
                      )
             ),
             hidden(tags$div(id = "info_man_time_div",
                             fluidRow(
                               column(12, style = "padding-left:15px;padding-right:32px;",
                                      wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                                info_man_time_text
                                      )
                               )
                             )
             )),
             tags$div(id = "man_volume_div",
                      fluidRow(
                        column(10, style = "padding-left:15px;padding-right:10px;",
                               sliderInput("man_cp_volume", label = NULL, width = "100%",
                                           value = 1, min = 0.1, max = 10, step = 0.001)
                        ),
                        column(2, style = "padding-right:32px;", align="right",
                               circleButton("info_man_volume", "",
                                            icon = icon("info"), status = "primary",
                                            size = "xs", style="font-size:60%")
                        )
                      )
             ),
             tags$div(id = "man_flow_div",
                      fluidRow(
                        column(10, style = "padding-left:15px;padding-right:10px;",
                               sliderInput("man_cp_flow", label = NULL, width = "100%",
                                           value = 1, min = 0, max = 10, step = 0.00001)
                        ),
                        column(2, style = "padding-right:32px;", align="right",
                               circleButton("info_man_flow", "",
                                            icon = icon("info"), status = "primary",
                                            size = "xs", style="font-size:60%")
                        )
                      )
             ),
             hidden(tags$div(id = "info_man_vol_flow_div",
                             fluidRow(
                               column(12, style = "padding-left:15px;padding-right:32px;",
                                      wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                                info_man_vol_flow_text
                                      )
                               )
                             )
             )),
             tags$div(id = "man_function_div",
                      fluidRow(
                        column(5, style = "padding-top:10px;padding-left:15px;padding-right:0px;",
                               h5("Change function")
                        ),
                        column(7, style = "padding-top:10px;padding-right:32px;",
                               selectInput("function_type", label = NULL,
                                           choices = c("Linear", "Quadratic", "Sine"),
                                           selected = "Linear")
                        )
                      )
             ),
             br(),
             fluidRow(
               column(12, style = "padding-left:15px;padding-right:32px;", align="center",
                      bsButton("commit_man_change", "Apply change", style = "primary")
               )
             ),
             br()
             
    ))
  )