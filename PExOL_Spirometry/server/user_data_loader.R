# Load data from file
observeEvent(input$file, {
  req(input$file)
  file <- input$file
  if (endsWith(file$name, ".csv")) {
    # load data
    df_temp <- readCSV(file$datapath)
    # remove rows with NAs
    df_temp <- na.omit(df_temp)
    # check data
    data_check <- checkRawData(df_temp)
    if (data_check == TRUE) {
      df_user_data <<- df_temp
      updatePickerInput(session, "user_trials", choices = unique(df_temp$ID))
    }
  }
})

# Load data from samples
observeEvent(input$load_sample, {
  filename_raw <- paste0(input$sample_file, "raw.csv")
  filename_meta <- paste0(input$sample_file, "meta.csv")
  # load raw data
  df_temp <- readCSV(filename_raw)
  # remove rows with NAs
  df_temp <- na.omit(df_temp)
  # check data
  data_check <- checkRawData(df_temp)
  if (data_check == TRUE) {
    df_user_data <<- df_temp
    updatePickerInput(session, "user_trials", choices = unique(df_user_data$ID))
    # check for meta file
    if (file.exists(filename_meta)) {
      # load meta data
      df_temp2 <- readCSV(filename_meta)
      data_check2 <- checkUserMetaData(df_temp2)
      if (data_check2 == TRUE) {
        reactive_sample_data_meta$df <- df_temp2
        show("sample_meta_text")
      } else {
        hide("sample_meta_text")
      }
    } else {
      hide("sample_meta_text")
    }
  }
})

# display sample meta data
output$sample_meta_text <- renderText({
  req(reactive_sample_data_meta$df)
  # maximum of 10 entries get displayed
  n_entries <- min(nrow(reactive_sample_data_meta$df), 10)
  text <- "<div style='background-color:rgb(245, 245, 245);'> <font size='2'><center><b>Dataset Information:</b></center>"
  for (i in 1:n_entries) {
    text <- paste0(text, "&nbsp<b>", reactive_sample_data_meta$df$Category[i], ": </b>", reactive_sample_data_meta$df$Value[i], "<br/>")
  }
  HTML(text)
})

