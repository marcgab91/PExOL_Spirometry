tab_reference_data <-
  verticalTabPanel(
    tags$style(".no-line-break { white-space: nowrap; }"),
    title = div(class = "no-line-break", h6(HTML("Reference Data"))),
    box_height = "50px",
    fluidRow(
      column(8, style = "padding-left:15px;",
             selectInput("reference_data", h5("Reference Data:"),
                         choices = c())
      ),
      column(4, style = "padding-left:15px;",
             br(),
             br(),
             bsButton("load_ref", "Load", style = "primary")
      )
    ),
    hidden(tags$div(id = "ref_data_div",
             fluidRow(
               column(12, style = "padding-top:8px;padding-left:15px;padding-right:35px;text-align:center;",
                      tags$style(HTML("#ref_table_select_all { font-size: 12px; }")),
                      actionButton("ref_table_select_all", "Select All"),
                      tags$style(HTML("#ref_table_deselect_all { font-size: 12px; }")),
                      actionButton("ref_table_deselect_all", "Deselect All")
               )
             ),
             fluidRow(
               column(12, style = "padding-left:15px;padding-right:35px;",
                      div(
                        DT::dataTableOutput("reference_meta_table"),
                        style = "font-size:85%"
                      )
               )
             ),
             br(),
             fluidRow(
               column(5, style = "padding-left:15px;padding-right:0px;",
                      h5("As background")
               ),
               column(2, style = "padding-top:8px",
                      materialSwitch("ref_data_background_switch", NULL, 
                                     value = FALSE, status = "primary")
               ),
               column(5, style = "padding-top:5px;padding-right:32px;", align="right",
                      circleButton("info_ref_data_background_switch", "",
                                   icon = icon("info"), status = "primary",
                                   size = "xs", style="font-size:60%")
               )
             ),
             hidden(tags$div(id = "info_ref_data_background_switch_div",
                             fluidRow(
                               column(12, style = "padding-left:15px;padding-right:32px;",
                                      wellPanel(style = "padding-top:10px;padding-bottom:0px;",
                                                info_ref_data_background_switch_text
                                      )
                               )
                             )
             ))
    ))
  )