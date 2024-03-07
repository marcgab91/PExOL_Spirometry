# Load reference data (meta & raw)
observeEvent(input$load_ref, {
  filename_raw <- paste0(input$reference_data, "raw.csv")
  filename_meta <- paste0(input$reference_data, "meta.csv")
  df_temp_raw <- readCSV(filename_raw)
  df_temp_meta <- readCSV(filename_meta)
  # remove rows with NAs
  df_temp_raw <- na.omit(df_temp_raw)
  df_temp_meta <- na.omit(df_temp_meta)
  # check data
  ref_data_raw_check <- checkRawData(df_temp_raw)
  ref_data_meta_check <- checkRefMetaData(df_temp_meta)
  if (ref_data_raw_check == TRUE && ref_data_meta_check == TRUE) {
    ref_data_combined_check <- checkCombinedData(df_temp_raw, df_temp_meta)
    if (ref_data_combined_check == TRUE) {
      df_ref_data_raw <<- df_temp_raw
      reactive_ref_data_meta$df <- df_temp_meta
      # show rest of ref data tab
      show("ref_data_div")
    }
  }
})

# display reference meta data
output$reference_meta_table <- renderDT({
  req(reactive_ref_data_meta$df)
  datatable(reactive_ref_data_meta$df,
            selection = "multiple",
            rownames = FALSE,
            options = list(scrollX = TRUE,
                           scrollY = "calc(100vh - 400px)",
                           columnDefs = list(list(className = 'dt-center', targets = "_all")),
                           lengthMenu = list(c(10), c(10)),
                           paging = FALSE,
                           searching = FALSE,
                           info = FALSE,
                           sort = TRUE,
                           lengthChange = FALSE
                      )
  ) %>%
  formatStyle(columns = names(reactive_ref_data_meta$df),
              whiteSpace = "nowrap")
})

# select all rows of reference_meta_table
observeEvent(input$ref_table_select_all, {
  req(reactive_ref_data_meta$df)
  selected_rows <- c(1:nrow(reactive_ref_data_meta$df))
  proxy = dataTableProxy("reference_meta_table")
  selectRows(proxy, selected_rows)
})

# deselect all rows of reference_meta_table
observeEvent(input$ref_table_deselect_all, {
  req(reactive_ref_data_meta$df)
  proxy = dataTableProxy("reference_meta_table")
  selectRows(proxy, NULL)
})