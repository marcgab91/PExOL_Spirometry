# changing the time parameter triggers a data manipulation of the selected zone
observeEvent(input$man_range_time, {
  if (nrow(reactive_man_data$df) != 0) {
    # every change is singular; temp data is reset
    resetTempManData()
    # manipulate time
    adjustTime()
  }
})

# stretches or compresses the time of an area in the manipulated data
adjustTime <- function() {
  # constants
  original_start_time <- reactive_man_data$area$Time[1]
  original_end_time <- reactive_man_data$area$Time[3]
  original_time_range <- original_end_time - original_start_time
  new_time_range <- input$man_range_time
  new_start_time <- original_start_time
  new_end_time <- new_start_time + new_time_range
  time_change <- new_time_range - original_time_range
  # case 1: a single point gets duplicated
  if (original_time_range == 0) {
    # save the single time point
    df_single_time <- reactive_man_data$temp[reactive_man_data$temp$Time == original_start_time, ]
    # remove the time point
    reactive_man_data$temp <- reactive_man_data$temp[!(reactive_man_data$temp$Time == original_start_time), ]
    # adjust the later time points
    reactive_man_data$temp$Time[reactive_man_data$temp$Time > original_start_time] <- reactive_man_data$temp$Time[reactive_man_data$temp$Time > original_start_time] + time_change
    # create new times
    evenly_spaced_time <- seq(new_start_time, new_end_time, by = 0.01)
    df_even_zone <- data.frame(ID = df_single_time$ID[1],
                                   DS_Name = df_single_time$DS_Name[1],
                                   DS_Trial_ID = df_single_time$DS_Trial_ID[1],
                                   Time = evenly_spaced_time,
                                   Volume = df_single_time$Volume[1],
                                   Flow = df_single_time$Flow[1])
    # add the new time frame
    reactive_man_data$temp <- rbind(reactive_man_data$temp, df_even_zone)
  } else if (new_time_range == 0) { # case 2: points get removed
    # remove the time frame
    reactive_man_data$temp <- reactive_man_data$temp[!(reactive_man_data$temp$Time >= original_start_time & reactive_man_data$temp$Time <= original_end_time), ]
    # adjust the later time points
    reactive_man_data$temp$Time[reactive_man_data$temp$Time > original_end_time] <- reactive_man_data$temp$Time[reactive_man_data$temp$Time > original_end_time] + time_change
  } else { # case 3: points get stretched/compressed
    # distributing (stretching/compressing) the points evenly across the new time range
    df_uneven_zone <- reactive_man_data$temp[reactive_man_data$area$Index_in_DF[1]:reactive_man_data$area$Index_in_DF[3], ]
    original_step_amount <- nrow(df_uneven_zone)
    unevenly_spaced_time <- seq(new_start_time, new_end_time, length.out = original_step_amount)
    df_uneven_zone$Time <- unevenly_spaced_time
    # initiating a new time range with 0.01s distances
    evenly_spaced_time <- seq(new_start_time, new_end_time, by = 0.01)
    # linear interpolation to get the volume values of the new time steps
    df_even_zone <- df_uneven_zone[FALSE, ]
    df_uneven_zone <- df_uneven_zone[order(df_uneven_zone$Time), ]
    id <- df_uneven_zone$ID[1]
    ds_name <- df_uneven_zone$DS_Name[1]
    ds_trial_id <- df_uneven_zone$DS_Trial_ID[1]
    for (t in evenly_spaced_time) {
      # if t already exists, its volume is transferred
      if (t %in% df_uneven_zone$Time) {
        v_of_t <- df_uneven_zone$Volume[df_uneven_zone$Time == t]
      } else {
        # find the index of the first time greater than t
        i <- min(which(df_uneven_zone$Time > t))
        # linear interpolate the volume of t
        v_of_t <- linearInterpolation(df_uneven_zone$Time[i-1],
                                      df_uneven_zone$Volume[i-1],
                                     df_uneven_zone$Time[i],
                                     df_uneven_zone$Volume[i],
                                     t)
      }
      # add to df
      new_tuple <- data.frame(ID = id,
                              DS_Name = ds_name,
                              DS_Trial_ID = ds_trial_id,
                              Time = t,
                              Volume = v_of_t,
                              Flow = 1)
      df_even_zone <- rbind(df_even_zone, new_tuple)
    }
    # adjust the manipulated dataframe
    # remove the time frame
    reactive_man_data$temp <- reactive_man_data$temp[!(reactive_man_data$temp$Time >= original_start_time & reactive_man_data$temp$Time <= original_end_time), ]
    # adjust the later time points
    reactive_man_data$temp$Time[reactive_man_data$temp$Time > original_end_time] <- reactive_man_data$temp$Time[reactive_man_data$temp$Time > original_end_time] + time_change
    # add the new time frame
    reactive_man_data$temp <- rbind(reactive_man_data$temp, df_even_zone)
  }
  
  # rearrange the manipulated dataframe
  # order
  reactive_man_data$temp <- reactive_man_data$temp[order(reactive_man_data$temp$Time), ]
  # reset row index
  rownames(reactive_man_data$temp) <- NULL
  # making sure, that all times are in 0.01s steps
  reactive_man_data$temp$Time <- round(reactive_man_data$temp$Time, 2)
  
  # update flow
  recalculateManData("Flow")
}
