# load file paths
reactive_paths <- reactiveValues(df = data.frame(Name = character(),
                                                 Path = character(),
                                                 Type = character()))
reactive_paths$df <- readCSV("data/paths.csv")

# loads all data paths and updates the selectInputs
observe({
  # load sample paths
  df_samples <- subset(reactive_paths$df, Type == "Sample")
  samples <- setNames(df_samples$Path, df_samples$Name)
  updateSelectInput(session, "sample_file", choices = samples)
  # load reference paths
  df_refs <- subset(reactive_paths$df, Type == "Reference")
  refs <- setNames(df_refs$Path, df_refs$Name)
  updateSelectInput(session, "reference_data", choices = refs)
})

# Event: changing loading type
observeEvent(input$load_type, {
  if (input$load_type == "Upload") {
    show("upload_div")
    hide("sample_div")
  }
  if (input$load_type == "Sample") {
    hide("upload_div")
    show("sample_div")
  }
})

# Event: changes the picker inputs of the animated and manipulated trials,
# depending on changes in reactive_plot_data$df
observe({
  if (nrow(reactive_plot_data$df) != 0) {
    # get one row of each unique id
    df_unique <- reactive_plot_data$df %>%
      group_by(ID) %>%
      slice(1) %>%
      ungroup()
    # create a named vector
    trials <- c()
    for (i in 1:nrow(df_unique)) {
      id <- df_unique$ID[i]
      ds_name <- df_unique$DS_Name[i]
      trial_id <- df_unique$DS_Trial_ID[i]
      combined_name <- paste(ds_name, "-", trial_id)
      trial <- setNames(id, combined_name)
      trials <- c(trials, trial)
    }
    # manipulation trials: keep the current selection
    current_selection <- isolate(input$starting_trial)
    if (current_selection %in% trials) {
      updateSelectInput(session, "starting_trial", choices = trials, selected = current_selection)
    } else {
      updateSelectInput(session, "starting_trial", choices = trials)
    }
    # animation trials: add manipulated trial
    if (nrow(reactive_man_data$df) != 0) {
      trial <- setNames("man_data_0", "Manipulated data - 0")
      trials <- c(trials, trial)
    }
    updatePickerInput(session, "animated_trials", choices = trials)
  } else {
    updatePickerInput(session, "animated_trials", choices = " ")
    updateSelectInput(session, "starting_trial", choices = " ")
  }
})

# Event: new manipulated trial created
observeEvent(input$create_manipulated_trial, {
  if (input$starting_trial != " ") {
    show("man_div")
    hide("create_manipulated_trial")
    show("reset_manipulated_trial")
  }
})

# Event: reset manipulated trial
observeEvent(input$reset_manipulated_trial, {
  hide("man_div")
  show("create_manipulated_trial")
  hide("reset_manipulated_trial")
})

# Event: changing manipulation parameter
observeEvent(input$man_para, {
  hide("info_man_time_div")
  hide("info_man_vol_flow_div")
  if (input$man_para == "Time") {
    show("man_time_div")
    hide("man_volume_div")
    hide("man_flow_div")
    hide("man_function_div")
  }
  if (input$man_para == "Volume") {
    hide("man_time_div")
    show("man_volume_div")
    hide("man_flow_div")
    show("man_function_div")
  }
  if (input$man_para == "Flow") {
    hide("man_time_div")
    hide("man_volume_div")
    show("man_flow_div")
    show("man_function_div")
  }
  if (nrow(reactive_man_data$df) != 0) {
    updateManInputs()
  }
})
