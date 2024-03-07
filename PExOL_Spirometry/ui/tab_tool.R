# load dependencies
source("ui/sidebar/overview_text.R")
source("ui/sidebar/info_texts.R")
source("ui/sidebar/tab_overview.R")
source("ui/sidebar/tab_user_data.R")
source("ui/sidebar/tab_reference_data.R")
source("ui/sidebar/tab_manipulation.R")
source("ui/sidebar/tab_animation.R")
source("ui/sidebar/tab_download.R")

tab_tool <- 
  tabPanel("Tool",
           fluidRow(
             # sidebar
             column(5, div(style = "min-width:400px;",
                           column(
                             12,
                             tags$head(
                               tags$style(HTML(".tab-content {height: calc(100vh - 150px) !important;}"))
                             ),
                             tags$head(
                               tags$style(HTML(".col-sm-9 {overflow-x: hidden; overflow-y: auto;}")) #scrollbar for vertical_tabsetpanel
                             ),
                             verticalTabsetPanel(
                               id = "vertical_tabsetpanel",
                               contentWidth = 9,
                               color = "#397eb9",
                               tab_overview,
                               tab_user_data,
                               tab_reference_data,
                               tab_manipulation,
                               tab_animation,
                               tab_download
                             )
                           )
             )),
             # main panel
             column(7,
                    radioGroupButtons("plot_type", NULL,
                                      choices = c("Volume-Time-Diagram" = "volume_time", "Flow-Volume-Diagram" = "flow_volume", "Flow-Time-Diagram" = "flow_time"),
                                      justified = TRUE, status = "primary",
                                      checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon")),
                                      selected = c("volume_time")),
                    plotOutput("plot_static",
                               click = hoverOpts("plot_static_click"),
                               hover = hoverOpts("plot_static_hover", delay = 100, delayType = "debounce")),
                    uiOutput("hover_info"),
                    div(
                      DT::dataTableOutput("characteristics_table"),
                      style = "font-size:85%"
                    )
             )
           )
  )