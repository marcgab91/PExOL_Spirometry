# center point changes
observeEvent(input$man_center_point, {
  resetTempManData()
  determineManZone()
})

# range changes
observeEvent(input$man_range, {
  resetTempManData()
  determineManZone()
})

# determines first, center and last point of the manipulation zone
determineManZone <- function() {
  if (nrow(reactive_man_data$df) != 0) {
    center_index <- which(reactive_man_data$df$Time == input$man_center_point)
    range <- input$man_range * 100 #relative index = relative time * 100
    max <- nrow(reactive_man_data$df)
    # first point
    first_point <- NULL
    first_index <- center_index - range
    if (first_index < 1) {
      first_index <- 1
    }
    first_point <- reactive_man_data$df[first_index, ]
    first_point$Index_in_DF <- first_index
    first_point$Type <- "edge"
    # center point
    center_point <- reactive_man_data$df[center_index, ]
    center_point$Index_in_DF <- center_index
    center_point$Type <- "center"
    # last point
    last_point <- NULL
    last_index <- center_index + range
    if (last_index > max) {
      last_index <- max
    }
    last_point <- reactive_man_data$df[last_index, ]
    last_point$Index_in_DF <- last_index
    last_point$Type <- "edge"
    # combine into one df
    reactive_man_data$area <- rbind(first_point, center_point, last_point)
    # update inputs
    updateManInputs()
  }
}

# updates the manipulation inputs to the current values of the center point
updateManInputs <- function() {
  # time input
  T_value <- reactive_man_data$area$Time[3] - reactive_man_data$area$Time[1]
  T_min <- 0
  T_max <- round(T_value*2, 0) + 1
  updateSliderInput(session, "man_range_time", min = T_min, max = T_max, value = T_value)
  # volume input
  V_value <- reactive_man_data$area$Volume[2]
  V_min <- round(min(reactive_man_data$df$Volume), 0) - 2 #minimum - buffer of 2
  if (V_min > 0) {
    V_min <- 0
  }
  V_max <- round(max(reactive_man_data$df$Volume), 0) + 2 #maximum + buffer of 2
  if (V_max < 6) {
    V_max <- 6
  }
  dec <- getDecimalPlaces(V_value)
  V_step <- 0.1
  if (dec > 1) {
    if (dec > 5) {
      dec <- 5
    }
    V_step <- 1/(10**dec)
  }
  updateSliderInput(session, "man_cp_volume", min = V_min, max = V_max, value = V_value, step = V_step)
  # flow input
  F_value <- reactive_man_data$area$Flow[2]
  F_min <- round(min(reactive_man_data$df$Flow), 0) - 2 #minimum - buffer of 2
  if (F_min > -10) {
    F_min <- -10
  }
  F_max <- round(max(reactive_man_data$df$Flow), 0) + 2 #maximum + buffer of 2
  if (F_max < 10) {
    F_max <- 10
  }
  dec <- getDecimalPlaces(F_value)
  F_step <- 0.1
  if (dec > 1) {
    if (dec > 5) {
      dec <- 5
    }
    F_step <- 1/(10**dec)
  }
  updateSliderInput(session, "man_cp_flow", min = F_min, max = F_max, value = F_value, step = F_step)
}


