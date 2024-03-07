server <- function(input, output, session) {
  # load dependencies
  source("server/read_csv.R", local = TRUE)
  source("server/interactive_ui.R", local = TRUE)
  source("server/user_data_loader.R", local = TRUE)
  source("server/ref_data_loader.R", local = TRUE)
  source("server/plot_data_handling.R", local = TRUE)
  source("server/plot_output.R", local = TRUE)
  source("server/plot_parameters.R", local = TRUE)
  source("server/input_check.R", local = TRUE)
  source("server/characteristics_handling.R", local = TRUE)
  source("server/plot_hover.R", local = TRUE)
  source("server/animation.R", local = TRUE)
  source("server/animation_warning.R", local = TRUE)
  source("server/animation_loading_screen.R", local = TRUE)
  source("server/manipulation.R", local = TRUE)
  source("server/manipulation_zone.R", local = TRUE)
  source("server/manipulation_time.R", local = TRUE)
  source("server/manipulation_volume_flow.R", local = TRUE)
  source("server/plot_click.R", local = TRUE)
  source("server/linear_interpolation.R", local = TRUE)
  source("server/info_buttons.R", local = TRUE)
  source("server/notifications.R", local = TRUE)
  source("server/miscellaneous.R", local = TRUE)
  source("server/downloads.R", local = TRUE)
  
  # server-wide dataframes
  df_user_data <- data.frame(ID = character(),
                             Time = numeric(),
                             Volume = numeric(),
                             Flow = numeric())
  reactive_sample_data_meta <- reactiveValues(df = NULL)
  df_ref_data_raw <- data.frame(ID = character(),
                                Time = numeric(),
                                Volume = numeric(),
                                Flow = numeric())
  reactive_ref_data_meta <- reactiveValues(df = NULL)
  reactive_plot_data <- reactiveValues(df = data.frame(ID = character(),
                                                       DS_Name = character(),
                                                       DS_Trial_ID = character(),
                                                       Time = numeric(),
                                                       Volume = numeric(),
                                                       Flow = numeric()))
  reactive_man_data <- reactiveValues(df = data.frame(ID = character(),
                                                      DS_Name = character(),
                                                      DS_Trial_ID = character(),
                                                      Time = numeric(),
                                                      Volume = numeric(),
                                                      Flow = numeric()),
                                      temp = data.frame(ID = character(),
                                                        DS_Name = character(),
                                                        DS_Trial_ID = character(),
                                                        Time = numeric(),
                                                        Volume = numeric(),
                                                        Flow = numeric()),
                                      area = data.frame(ID = character(),
                                                        DS_Name = character(),
                                                        DS_Trial_ID = character(),
                                                        Time = numeric(),
                                                        Volume = numeric(),
                                                        Flow = numeric(),
                                                        Index_in_DF = numeric(),
                                                        Type = character()))
  reactive_char_data <- reactiveValues(table = data.frame(ID = character(),
                                                          DS_Name = character(),
                                                          DS_Trial_ID = character(),
                                                          t_start = numeric(),
                                                          Vol_start = numeric(),
                                                          t_flow_max = numeric(),
                                                          Flow_max = numeric(),
                                                          t_vol_max = numeric(),
                                                          Vol_max = numeric(),
                                                          t_flow_min = numeric(),
                                                          Flow_min = numeric(),
                                                          t_end = numeric(),
                                                          Vol_end = numeric()),
                                       plot = data.frame(ID = character(),
                                                         DS_Name = character(),
                                                         DS_Trial_ID = character(),
                                                         Time = numeric(),
                                                         Volume = numeric(),
                                                         Flow = numeric()))
  df_char_data_complete <- data.frame(ID = character(),
                                      DS_Name = character(),
                                      DS_Trial_ID = character(),
                                      t_start = numeric(),
                                      Vol_start = numeric(),
                                      t_flow_max = numeric(),
                                      Flow_max = numeric(),
                                      t_vol_max = numeric(),
                                      Vol_max = numeric(),
                                      t_flow_min = numeric(),
                                      Flow_min = numeric(),
                                      t_end = numeric(),
                                      Vol_end = numeric())
  
  # server-wide variables
  previous_selected_user_trials <- c()
  previous_selected_ref_trials <- c()
  
}

