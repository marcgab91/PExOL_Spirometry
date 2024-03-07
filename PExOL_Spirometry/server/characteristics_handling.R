# loads existing characteristics or calculates them
addCharacteristics <- function(id, dataset_name, trial_id, df) {
  df_char <- loadCharacteristics(id)
  # data already exists
  if (nrow(df_char) == 1) {
    reactive_char_data$table <- rbind(reactive_char_data$table, df_char)
  } else { # data does not exist
    df_char <- calculateCharacteristics(id, dataset_name, trial_id, df)
    reactive_char_data$table <- rbind(reactive_char_data$table, df_char)
    if (!(id %in% "man_data_0")) {
      df_char_data_complete <<- rbind(df_char_data_complete, df_char)
    }
  }
}

# loads characteristics (empty if no characteristics)
# and returns them
loadCharacteristics <- function(id) {
  df_char <- subset(df_char_data_complete, ID == id)
  return(df_char)
}

# calculates characteristics 
# and returns them
calculateCharacteristics <- function(id, dataset_name, trial_id, df) {
  # t start and Vol start
  t_start <- df$Time[1]
  vol_start <- round(df$Volume[1], 3)
  # t flow max and Flow max
  t_flow_max <- df$Time[which.max(df$Flow)]
  flow_max <- round(max(df$Flow), 3)
  # t vol max and Vol max
  t_vol_max <- df$Time[which.max(df$Vol)]
  vol_max <- round(max(df$Vol), 3)
  # t flow min and Flow min
  t_flow_min <- df$Time[which.min(df$Flow)]
  flow_min <- round(min(df$Flow), 3)
  # t end and Vol end
  t_end <- df$Time[nrow(df)]
  vol_end <- round(df$Volume[nrow(df)], 3)
  # creating df
  df_char <- data.frame(ID = id,
                        DS_Name = dataset_name,
                        DS_Trial_ID = trial_id,
                        t_start = t_start,
                        Vol_start = vol_start,
                        t_flow_max = t_flow_max,
                        Flow_max = flow_max,
                        t_vol_max = t_vol_max,
                        Vol_max = vol_max,
                        t_flow_min = t_flow_min,
                        Flow_min = flow_min,
                        t_end = t_end,
                        Vol_end = vol_end)
  return(df_char)
}

# removes loaded characteristics
removeCharacteristics <- function(id) {
  # remove char data of the specific id
  reactive_char_data$table <- reactive_char_data$table[reactive_char_data$table$ID != id, ]
}

# display reference meta data
output$characteristics_table <- renderDT({
  req(reactive_char_data$table)
  df_char <- reactive_char_data$table
  # "hide" the internal ID
  df_char$ID <- NULL
  # Rename columns
  names(df_char)[names(df_char) == "DS_Name"] <- "Dataset"
  names(df_char)[names(df_char) == "DS_Trial_ID"] <- "ID"
  names(df_char)[names(df_char) == "t_start"] <- "t<sub>start</sub>"
  names(df_char)[names(df_char) == "Vol_start"] <- "Vol<sub>start</sub>"
  names(df_char)[names(df_char) == "t_flow_max"] <- "t<sub>flow_max</sub>"
  names(df_char)[names(df_char) == "Flow_max"] <- "Flow<sub>max</sub>"
  names(df_char)[names(df_char) == "t_vol_max"] <- "t<sub>vol_max</sub>"
  names(df_char)[names(df_char) == "Vol_max"] <- "Vol<sub>max</sub>"
  names(df_char)[names(df_char) == "t_flow_min"] <- "t<sub>flow_min</sub>"
  names(df_char)[names(df_char) == "Flow_min"] <- "Flow<sub>min</sub>"
  names(df_char)[names(df_char) == "t_end"] <- "t<sub>end</sub>"
  names(df_char)[names(df_char) == "Vol_end"] <- "Vol<sub>end</sub>"
  datatable(df_char,
            selection = "single",
            rownames = FALSE,
            options = list(scrollX = TRUE,
                           scrollY = "280px",
                           columnDefs = list(list(className = 'dt-center', targets = "_all")),
                           lengthMenu = list(c(10), c(10)),
                           paging = FALSE,
                           searching = FALSE,
                           info = FALSE,
                           sort = TRUE,
                           lengthChange = FALSE
            ),
            escape = FALSE
  )
})

# Event: a characteristic gets selected or deselected
observeEvent(input$characteristics_table_rows_selected, {
  df_selected <- reactive_char_data$table[input$characteristics_table_rows_selected, ]
  id <- df_selected$ID[1]
  t_start <- df_selected$t_start[1]
  t_flow_max <- df_selected$t_flow_max[1]
  t_vol_max <- df_selected$t_vol_max[1]
  t_flow_min <- df_selected$t_flow_min[1]
  t_end <- df_selected$t_end[1]
  # get the data
  df <- reactive_plot_data$df
  if (id %in% "man_data_0") {
    df <- reactive_man_data$df
  }
  reactive_char_data$plot <- subset(df, ID == id & (Time == t_start | Time == t_flow_max | Time == t_vol_max | Time == t_flow_min | Time == t_end))
}, ignoreNULL = FALSE)