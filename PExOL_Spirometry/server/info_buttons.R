# Info-Event: info_upload_file
observeEvent(input$info_upload_file, {
  toggle("info_upload_file_div")
})

# Info-Event: info_ref_data_background_switch
observeEvent(input$info_ref_data_background_switch, {
  toggle("info_ref_data_background_switch_div")
})

# Info-Event: info_starting_trial
observeEvent(input$info_starting_trial, {
  toggle("info_starting_trial_div")
})

# Info-Event: info_zone
observeEvent(input$info_zone, {
  toggle("info_zone_div")
})

# Info-Event: info_man_time
observeEvent(input$info_man_time, {
  toggle("info_man_time_div")
})

# Info-Event: info_man_volume
observeEvent(input$info_man_volume, {
  toggle("info_man_vol_flow_div")
})

# Info-Event: info_man_flow
observeEvent(input$info_man_flow, {
  toggle("info_man_vol_flow_div")
})

# Info-Event: info_animation
observeEvent(input$info_animation, {
  toggle("info_animation_div")
})
