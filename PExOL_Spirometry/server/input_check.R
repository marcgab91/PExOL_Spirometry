# checks the content of uploaded raw data files
checkRawData <- function(df) {
  # check if dataframe is empty
  if (!nrow(df) == 0) {
    # check number and names of columns
    if ("ID" %in% colnames(df) &&
        "Time" %in% colnames(df) &&
        "Volume" %in% colnames(df) &&
        "Flow" %in% colnames(df) &&
        length(colnames(df)) == 4) {
      # check data types of columns
      if ((class(df$ID) %in% c("numeric", "integer", "character", "factor")) &&
          (class(df$Time) %in% c("numeric", "integer")) &&
          (class(df$Volume) %in% c("numeric", "integer")) &&
          (class(df$Flow) %in% c("numeric", "integer"))) {
        # check time for 10 ms intervals
        df_intervals <- df %>%
          group_by(ID) %>%
          reframe(interval = diff(Time))
        # all intervals are the same
        if (isTRUE(all.equal(max(df_intervals$interval), min(df_intervals$interval)))) {
          # the intervals are 10ms
          if (isTRUE(all.equal(df_intervals$interval[1], 0.01))) {
            return(TRUE)
          } else {
            displayNotification("wrong_intervals")
            return(FALSE)
          }
        } else {
          displayNotification("wrong_intervals")
          return(FALSE)
        }
      } else {
        displayNotification("wrong_datatype")
        return(FALSE)
      }
    } else {
      displayNotification("wrong_columns")
      return(FALSE)
    }
  } else {
    displayNotification("empty_dataset")
    return(FALSE)
  }
}

# checks the content of uploaded user meta data files
checkUserMetaData <- function(df) {
  # check if dataframe is empty
  if (!nrow(df) == 0) {
    # check number and names of columns
    if ("Category" %in% colnames(df) &&
        "Value" %in% colnames(df) &&
        length(colnames(df)) == 2) {
      return(TRUE)
    } else {
      displayNotification("wrong_columns")
      return(FALSE)
    }
  } else {
    displayNotification("empty_dataset")
    return(FALSE)
  }
}

# checks the content of uploaded reference meta data files
checkRefMetaData <- function(df) {
  # check if dataframe is empty
  if (!nrow(df) == 0) {
    # check if a column named ID is available
    if ("ID" %in% colnames(df)) {
        return(TRUE)
    } else {
      displayNotification("wrong_columns")
      return(FALSE)
    }
  } else {
    displayNotification("empty_dataset")
    return(FALSE)
  }
}

# checks compatibility of uploaded raw data and meta data files
checkCombinedData <- function(df_raw, df_meta) {
  # check if both dfs contain the same ids
  if (identical(unique(df_raw$ID), df_meta$ID) ) {
    return(TRUE)
  } else {
    displayNotification("not_matching_ids")
    return(FALSE)
  }
}
