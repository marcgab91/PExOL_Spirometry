# changing the volume parameter triggers a data manipulation of the selected zone
observeEvent(input$man_cp_volume, {
  doManipulationVF("Volume", input$man_cp_volume)
})

# changing the flow parameter triggers a data manipulation of the selected zone
observeEvent(input$man_cp_flow, {
  doManipulationVF("Flow", input$man_cp_flow)
})

# changing the function type triggers a data manipulation of the selected zone
observeEvent(input$function_type, {
  if (input$man_para == "Volume") {
    doManipulationVF("Volume", input$man_cp_volume)
  }
  if (input$man_para == "Flow") {
    doManipulationVF("Flow", input$man_cp_flow)
  }
})

# starts the manipulation process for Flow or Volume
doManipulationVF <- function(para_type, value) {
  if (nrow(reactive_man_data$df) != 0) {
    # every change is singular; temp data is reset
    resetTempManData()
    if (input$man_range == 0) {
      # single point manipulation
      singlePointManipulationVF(para_type, value)
    } else {
      # multiple points manipulation (depending on function type)
      switch(
        input$function_type,
        "Linear" = linearManipulationVF(para_type, value),
        "Quadratic" = quadraticManipulationVF(para_type, value),
        "Sine" = sineManipulationVF(para_type, value)
      )
    }
  }
}

# scales a single point to the desired input
singlePointManipulationVF <- function(para_type, value) {
  index <- reactive_man_data$area$Index_in_DF[1]
  reactive_man_data$temp[index, para_type] <- value
  
  # update the volume or flow values
  switch(
    para_type,
    "Volume" = recalculateManData("Flow"),
    "Flow" = recalculateManData("Volume")
  )
}

# linear manipulation of Volume or Flow
# two linear functions get calculated
# on basis of two points each (edge to center point to edge)
# and their values for each time point get added to the values of the trial
# function expression f(x)=mx+b
#
#       x
#      x x
#     x   x
#    x     x
#   x       x
#
linearManipulationVF <- function(para_type, value) {
  index_start <- reactive_man_data$area$Index_in_DF[1]
  index_center <- reactive_man_data$area$Index_in_DF[2]
  index_end <- reactive_man_data$area$Index_in_DF[3]
  diff <- value - reactive_man_data$df[index_center, para_type]
  
  # first half (including center point)
  x1 <- index_start
  x2 <- index_center
  y1 <- 0
  y2 <- diff
  # differentiate between a single point and multiple points
  if ((x2 - x1) != 0) {
    # slope m = (y2-y1)/(x2-x1)
    m <- (y2 - y1) / (x2 - x1)
    # intercept b = y-mx
    b <- y1 - m * x1
    # calculate the new values
    for (i in index_start:index_center) {
      y <- m * i + b
      reactive_man_data$temp[i, para_type] <- reactive_man_data$df[i, para_type] + y
    }
  } else {
    reactive_man_data$temp[index_center, para_type] <- value
  }
  
  # second half (excluding center point)
  x1 <- index_center
  x2 <- index_end
  y1 <- diff
  y2 <- 0
  # only necessary, if there are points after the center
  if ((x2 - x1) != 0) {
    # gradient m = (y2-y1)/(x2-x1)
    m <- (y2 - y1) / (x2 - x1)
    # intercept b = y-mx
    b = y1 - m * x1
    # calculate the new values
    for (i in (index_center+1):index_end) {
      y <- m * i + b
      reactive_man_data$temp[i, para_type] <- reactive_man_data$df[i, para_type] + y
    }
  }
  
  # update the volume or flow values
  switch(
    para_type,
    "Volume" = recalculateManData("Flow"),
    "Flow" = recalculateManData("Volume")
  )
}

# quadratic manipulation of Volume or Flow
# two quadratic functions get calculated
# on basis of three points each (edge to center to mirrored edge)
# and their values for each time point get added to the values of the trial
# function expression f(x)=ax^2+bx+c
#
#     xx
#    x  x
#    x  x
#   x    x
#   x    x
#
quadraticManipulationVF <- function(para_type, value) {
  index_start <- reactive_man_data$area$Index_in_DF[1]
  index_center <- reactive_man_data$area$Index_in_DF[2]
  index_end <- reactive_man_data$area$Index_in_DF[3]
  diff <- value - reactive_man_data$df[index_center, para_type]
  
  # first half (including center point)
  # three points needed (start point gets mirrored)
  x1 <- index_start
  y1 <- 0
  x2 <- index_center
  y2 <- diff
  x3 <- 2 * index_center - index_start
  y3 <- 0
  # differentiate between a single point and multiple points
  if ((x2 - x1) != 0) {
    # solve the system of equations
    # y1 = ax1^2 + bx1 + c
    # y2 = ax2^2 + bx2 + c
    # y3 = ax3^2 + bx3 + c
    M <- matrix(c(x1**2, x2**2, x3**2, x1, x2, x3, 1, 1, 1), ncol = 3)
    Y <- c(y1, y2, y3)
    coeff <- solve(M, Y)
    a <- coeff[1]
    b <- coeff[2]
    c <- coeff[3]
    # calculate the new values
    for (i in index_start:index_center) {
      y <- a * (i^2) + b * i + c
      reactive_man_data$temp[i, para_type] <- reactive_man_data$df[i, para_type] + y
    }
  } else {
    reactive_man_data$temp[index_center, para_type] <- value
  }
  
  # second half (excluding center point)
  # three points needed (end point gets mirrored)
  x1 <- index_center - (index_end - index_center)
  y1 <- 0
  x2 <- index_center
  y2 <- diff
  x3 <- index_end
  y3 <- 0
  # only necessary, if there are points after the center
  if ((x3 - x2) != 0) {
    # solve the system of equations
    # y1 = ax1^2 + bx1 + c
    # y2 = ax2^2 + bx2 + c
    # y3 = ax3^2 + bx3 + c
    M <- matrix(c(x1**2, x2**2, x3**2, x1, x2, x3, 1, 1, 1), ncol = 3)
    Y <- c(y1, y2, y3)
    coeff <- solve(M, Y)
    a <- coeff[1]
    b <- coeff[2]
    c <- coeff[3]
    # calculate the new values
    for (i in (index_center+1):index_end) {
      y <- a * (i^2) + b * i + c
      reactive_man_data$temp[i, para_type] <- reactive_man_data$df[i, para_type] + y
    }
  }
  
  # update the volume or flow values
  switch(
    para_type,
    "Volume" = recalculateManData("Flow"),
    "Flow" = recalculateManData("Volume")
  )
}

# sine manipulation of Volume or Flow
# two sine functions get calculated
# and their values for each time point get added to the values of the trial
# function expression f(x)=A*sin(2*pi*B*(x+C))+D
# with A .. amplitude, B .. frequency, C .. phase shift, D .. vertical shift
#
#           xxx
#         xx   xx
#        x       x
#       x         x
#     xx           xx
#   xx               xx
#
sineManipulationVF <- function(para_type, value) {
  index_start <- reactive_man_data$area$Index_in_DF[1]
  index_center <- reactive_man_data$area$Index_in_DF[2]
  index_end <- reactive_man_data$area$Index_in_DF[3]
  diff <- value - reactive_man_data$df[index_center, para_type]
  
  # differentiate between a single point and multiple points
  if ((index_center - index_start) != 0) {
    # first half (including center point)
    # amplitude A: half the height at the center point
    A <- diff/2
    # frequency B: half an oscillation is done from start to center
    t <- 2 * (index_center - index_start)
    B <- 1/t
    # phase shift C: equals the start of the manipulated area and a quarter of an oscillation
    C <- -index_start - t/4
    # vertical shift D: from 0 to diff
    D <- A
    # calculate the new values
    for (i in index_start:index_center) {
      y <- A * sinpi(2 * B * (i + C)) + D
      reactive_man_data$temp[i, para_type] <- reactive_man_data$df[i, para_type] + y
    }
  } else {
    reactive_man_data$temp[index_center, para_type] <- value
  }
  
  # second half (excluding center point)
  # only necessary, if there are points after the center
  if ((index_end - index_center) != 0) {
    # amplitude A: half the height at the center point
    A <- diff/2
    # frequency B: half an oscillation is done from start to center
    t <- 2 * (index_end - index_center)
    B <- 1/t
    # phase shift C: equals the start of the manipulated area and a quarter of an oscillation
    C <- -index_center + t/4
    # vertical shift D: from 0 to diff
    D <- A
    # calculate the new values
    for (i in (index_center+1):index_end) {
      y <- A * sinpi(2 * B * (i + C)) + D
      reactive_man_data$temp[i, para_type] <- reactive_man_data$df[i, para_type] + y
    }
  }
  
  # update the volume or flow values
  switch(
    para_type,
    "Volume" = recalculateManData("Flow"),
    "Flow" = recalculateManData("Volume")
  )
}

# recalculates flow or volume based on the corresponding other parameter
recalculateManData <- function(para_type) {
  switch(
    para_type,
    "Flow" = reactive_man_data$temp$Flow <- c(reactive_man_data$df$Flow[1], diff(reactive_man_data$temp$Volume)*100), # *100, because its per 10ms
    "Volume" = 
      {
        reactive_man_data$temp$Volume <- cumsum(reactive_man_data$temp$Flow)/100
        reactive_man_data$temp$Volume <- reactive_man_data$temp$Volume + (reactive_man_data$df$Volume[1] - reactive_man_data$df$Flow[1]/100) # adding the original volume offset
      }
  )
}
