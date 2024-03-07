# Event: a user trial gets selected or deselected
observeEvent(input$user_trials, {
  # find the selected/deselected trial ids
  diff_trial_ids <- determineVectorDifference(input$user_trials, previous_selected_user_trials)
  added_trial_ids <- diff_trial_ids$A
  removed_trial_ids <- diff_trial_ids$B
  # adding new trials
  if (length(added_trial_ids) > 0) {
    for (id in added_trial_ids) {
      df_trial <- subset(df_user_data, ID == id)
      combined_id <- createCombinedId("user_data", id)
      dataset_name = "User data"
      trial_id = id
      addTrialToPlotData(combined_id, dataset_name, trial_id, df_trial)
      addCharacteristics(combined_id, dataset_name, trial_id, df_trial)
    }
  }
  # removing trials
  if (length(removed_trial_ids) > 0) {
    for (id in removed_trial_ids) {
      combined_id <- createCombinedId("user_data", id)
      removeTrialFromPlotData(combined_id)
      removeCharacteristics(combined_id)
    }
  }
  previous_selected_user_trials <<- input$user_trials
}, ignoreNULL = FALSE)

# Event: a reference trial gets selected or deselected
observeEvent(input$reference_meta_table_rows_selected, {
  selected_ref_trials <- reactive_ref_data_meta$df$ID[input$reference_meta_table_rows_selected]
  # find the selected/deselected trial ids
  diff_trial_ids <- determineVectorDifference(selected_ref_trials, previous_selected_ref_trials)
  added_trial_ids <- diff_trial_ids$A
  removed_trial_ids <- diff_trial_ids$B
  # adding new trials
  if (length(added_trial_ids) > 0) {
    for (id in added_trial_ids) {
      df_trial <- subset(df_ref_data_raw, ID == id)
      combined_id <- createCombinedId("ref_data", id)
      dataset_name = "Reference data"
      trial_id = id
      addTrialToPlotData(combined_id, dataset_name, trial_id, df_trial)
      addCharacteristics(combined_id, dataset_name, trial_id, df_trial)
    }
  }
  # removing trials
  if (length(removed_trial_ids) > 0) {
    for (id in removed_trial_ids) {
      combined_id <- createCombinedId("ref_data", id)
      removeTrialFromPlotData(combined_id)
      removeCharacteristics(combined_id)
    }
  }
  previous_selected_ref_trials <<- selected_ref_trials
}, ignoreNULL = FALSE)

# returns the differences (elements) between two vectors
determineVectorDifference <- function(vectorA, vectorB) {
  uniqueA <- setdiff(vectorA, vectorB)
  uniqueB <- setdiff(vectorB, vectorA)
  difference <- list(A = uniqueA, B = uniqueB)
  return(difference)
}

# adds a trial to df_plot_data
addTrialToPlotData <- function(id, dataset_name, trial_id, df_trial) {
  # adding trial data to the plot data
  df_trial$ID <- id
  df_trial$DS_Name <- dataset_name
  df_trial$DS_Trial_ID <- trial_id
  reactive_plot_data$df <- rbind(reactive_plot_data$df, df_trial)
}

# removes a trial from df_plot_data
removeTrialFromPlotData <- function(id) {
  # removing trial data from the plot data
  reactive_plot_data$df <- reactive_plot_data$df[reactive_plot_data$df$ID != id, ]
}

# creates a combined id from dataset name and original trial id
createCombinedId <- function(dataset_name, trial_id) {
  id <- paste0(dataset_name, "_", trial_id)
  return(id)
}

# when manipulated data changes, characteristics get updated
observe({
  # trigger
  reactive_man_data$df
  # if there is already manipulated data, it gets removed from plot data and characteristics
  isolate({
    id <- "man_data_0"
    removeCharacteristics(id)
    # add new manipulated data to plot data and characteristics
    if (nrow(reactive_man_data$df) != 0) {
      id <- reactive_man_data$df$ID[1]
      dataset_name <- reactive_man_data$df$DS_Name[1]
      trial_id <- reactive_man_data$df$DS_Trial_ID[1]
      addCharacteristics(id, dataset_name, trial_id, reactive_man_data$df)
    }
  })
})