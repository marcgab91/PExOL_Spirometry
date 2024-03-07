# load dependencies
source("ui/tab_tool.R")
source("ui/tab_contact.R")

ui <- fluidPage(
  useShinyjs(),
  
  # Last tab in navbar (contact) is right-justified
  tags$head(
    tags$style(HTML("
                    .navbar-nav {
                      float: none !important;
                    }
                    .navbar-nav > li:nth-child(2) {
                      float: right;
                    }
    "))
  ),
  
  navbarPage(HTML("P<i>Ex</i>OL<sub style='font-size:12px;'>Spirometry</sub>"),
             windowTitle = "PExOL Spirometry",
             id = "navbar",
             tab_tool,
             tab_contact
  )
)
