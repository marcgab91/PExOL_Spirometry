# displays a message in the bottom right corner
displayNotification <- function(choice) {
  color = "default"
  notification = ""
  switch(   
    choice,
    "empty_dataset" = {
      notification = "The dataset is empty."
      color = "error"},
    "wrong_columns" = {
      notification = paste0("The columns do not meet the required specifications.")
      color = "error"},
    "wrong_datatype" = {
      notification = paste("The data types do not meet the required specifications.")
      color = "error"},
    "wrong_intervals" = {
      notification = paste0("The times are not in 0.01s intervals.")
      color = "error"},
    "not_matching_ids" = {
      notification = "The IDs of the raw dataset do not match the IDs of the meta dataset."
      color = "error"}
  ) 
  showNotification(notification, duration = 20, type = color)
}
