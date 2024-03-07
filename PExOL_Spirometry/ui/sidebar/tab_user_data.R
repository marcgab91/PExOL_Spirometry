tab_user_data <- 
  verticalTabPanel(
    title = h6("User Data"),
    box_height = "50px",
    br(),
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;",
             radioGroupButtons("load_type", NULL,
                               choices = c("Upload", "Sample"), justified = TRUE, status = "primary",
                               checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon")),
                               selected = c("Upload"))
      )
    ),
    tags$div(id = "upload_div",
             fluidRow(
               column(10, style = "padding-left:15px;",
                      h5("File (csv):")
               ),
               column(2, style = "padding-top:7px;padding-right:32px;", align="right",
                      circleButton("info_upload_file", "",
                                   icon = icon("info"), status = "primary",
                                   size = "xs", style="font-size:60%")
               )
             ),
             hidden(tags$div(id = "info_upload_file_div",
                             fluidRow(
                               column(12, style = "padding-left:15px;padding-right:32px;",
                                      wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                                info_upload_file_text
                                      )
                               )
                             )
             )),
             fluidRow(
               column(12, style = "padding-top:5px;padding-left:15px;padding-right:32px;",
                      fileInput("file", NULL,
                                accept = c(".csv"))
               )
             )
    ),
    hidden(
      tags$div(id = "sample_div",
               fluidRow(
                 column(8, style = "padding-left:15px;",
                        selectInput("sample_file", h5("Data:"),
                                    choices = c())
                 ),
                 column(4, style = "padding-left:15px;",
                        br(),
                        br(),
                        actionButton("load_sample", "Load")
                 )
               ),
               br()
      )
    ),
    fluidRow(
      column(12, style = "padding-top:5px;padding-left:15px;padding-right:32px;",
             pickerInput("user_trials", h5("Choose trials:"),
                         options = list(
                           `actions-box` = TRUE, 
                           size = 12
                         ),
                         choices = c(),
                         multiple = TRUE)
      )
    ),
    br(),
    fluidRow(
      column(12, style = "padding-left:15px;padding-right:32px;",
            htmlOutput("sample_meta_text")
      )
    )
  )