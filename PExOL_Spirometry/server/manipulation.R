# new manipulated trial gets created
observeEvent(input$create_manipulated_trial, {
  if (input$starting_trial != " ") {
    reactive_man_data$df <- subset(isolate(reactive_plot_data$df), ID == input$starting_trial)
    reactive_man_data$df$ID <- "man_data_0"
    reactive_man_data$df$DS_Name <- "Manipulated data"
    reactive_man_data$df$DS_Trial_ID <- "0"
    # initiate temp data
    resetTempManData()
    # update the center point and range numeric input
    max <- max(reactive_man_data$df$Time)
    min <- min(reactive_man_data$df$Time)
    diff <- max - min
    range <- round(diff/8, 2)
    cp <- min + round(diff/2, 2)
    updateSliderInput(session, "man_center_point", min = min, max = max, value = cp)
    updateSliderInput(session, "man_range", min = 0, max = max, value = range)
  }
})

# button commit
observeEvent(input$commit_man_change, {
  commitManChanges()
})

# changes made to the manipulated data get saved 
commitManChanges <- function() {
  if (nrow(reactive_man_data$temp) != 0) {
    reactive_man_data$df <- reactive_man_data$temp
    reactive_man_data$df$DS_Name <- "Manipulated data"
    
    # update the center point and range numeric input
    max <- max(reactive_man_data$df$Time)
    updateSliderInput(session, "man_center_point", max = max)
    updateSliderInput(session, "man_range", max = max)
    
    determineManZone()
    resetTempManData()
  }
}

# sets temporary manipulation data to commit manipulation data
resetTempManData <- function() {
  if (nrow(reactive_man_data$df) != 0) {
    reactive_man_data$temp <- reactive_man_data$df
    reactive_man_data$temp$DS_Name <- "Manipulated temp data"
  }
}

# reset manipulation tab
observeEvent(input$reset_manipulated_trial, {
  reactive_man_data$df <- data.frame(ID = character(),
                                     DS_Name = character(),
                                     DS_Trial_ID = character(),
                                     Time = numeric(),
                                     Volume = numeric(),
                                     Flow = numeric())
  reactive_man_data$temp <- data.frame(ID = character(),
                                       DS_Name = character(),
                                       DS_Trial_ID = character(),
                                       Time = numeric(),
                                       Volume = numeric(),
                                       Flow = numeric())
  reactive_man_data$area <- data.frame(ID = character(),
                                       DS_Name = character(),
                                       DS_Trial_ID = character(),
                                       Time = numeric(),
                                       Volume = numeric(),
                                       Flow = numeric(),
                                       Index_in_DF = numeric(),
                                       Type = character())
  updateSliderInput(session, "man_center_point", min = 1, max = 1, value = 1)
  updateSliderInput(session, "man_range", min = 1, max = 1, value = 1)
})

# when manipulated data changes, characteristics get updated
observe({
  # trigger
  reactive_man_data$df
  # if there is already manipulated data, it gets removed characteristics
  isolate({
    id <- "man_data_0"
    removeCharacteristics(id)
    # add new manipulated data to characteristics
    if (nrow(reactive_man_data$df) != 0) {
      id <- reactive_man_data$df$ID[1]
      dataset_name <- reactive_man_data$df$DS_Name[1]
      trial_id <- reactive_man_data$df$DS_Trial_ID[1]
      addCharacteristics(id, dataset_name, trial_id, reactive_man_data$df)
    }
  })
})
