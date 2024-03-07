library(dplyr)
library(ggplot2)

# loading the dataset
df_mbds <- read.csv("mbds/spirotidydatafinal.csv", sep = ",")

# changing time from ms to s
df_mbds$Time <- df_mbds$Time/1000

# adding a unique id to every trial
df_mbds$Trial_ID <- as.numeric(paste0(df_mbds$ID, df_mbds$Visit, df_mbds$Trial))

# initiating dataframes for RefMBDS
df_included_raw <- df_mbds[0,]
df_included_meta <- data.frame(ID = numeric(),
                               Trial_ID = numeric(),
                               VC = numeric())
df_excluded_raw <- df_mbds[0,]

# saving excluded trial ids
excluded_completeness_trial_ids <- c()

# loop through every trial
for (i in unique(df_mbds$Trial_ID)) {
  df_trial <- df_mbds[df_mbds$Trial_ID == i,]
  df_trial <- na.omit(df_trial)
  
  # finding the index of the global maximal volume (= tmax index),
  # which is also the maximal volume of the exspiration phase
  vexmax_index <- which.max(df_trial$Volume)
  vexmax <- max(df_trial$Volume)
  
  # cutting the (potential) second inspiration phase off
  df_trial_before_max_subset <- df_trial[1:vexmax_index-1, ]
  # finding the index of the minimal volume (= tstart index)
  vexmin_index <- which.min(df_trial_before_max_subset$Volume)
  vexmin <- min(df_trial_before_max_subset$Volume)
  
  # cutting the (potential) first three phases off,
  # if there is no second inspiration phase, the dataframe is size=1 (tmax)
  df_trial_from_max_subset <- df_trial[vexmax_index:nrow(df_trial), ]
  # finding the index of the minimal volume (= tend index)
  vinmin_index <- vexmax_index - 1 + which.min(df_trial_from_max_subset$Volume)
  vinmin <- min(df_trial_from_max_subset$Volume)
  
  # reducing the trial from tstart to tend
  df_breathing_cycle <- df_trial[vexmin_index:vinmin_index, ]
  df_breathing_cycle$Time_tstart <- df_breathing_cycle$Time - df_breathing_cycle$Time[1]
  df_breathing_cycle$Time <- NULL
  names(df_breathing_cycle)[names(df_breathing_cycle) == "Time_tstart"] <- "Time"
  
  # calculating FEVC, FIVC, their difference and VC
  fevc <- vexmax - vexmin
  fivc <- vexmax - vinmin
  diff <- abs(fevc - fivc)
  vc <- max(c(fevc, fivc))
  
  # checking completeness criterion
  if (diff <= 0.1 || diff <= 0.05*vc) {
    # adding VC to df_included_meta (for maximum criterion)
    tuple <- data.frame(ID = df_breathing_cycle$ID[1],
                        Trial_ID = i,
                        VC = vc)
    df_included_meta <- rbind(df_included_meta, tuple)
    # adding raw data to df_included_raw
    df_included_raw <- rbind(df_included_raw, df_breathing_cycle)
  } else {
    excluded_completeness_trial_ids <- c(excluded_completeness_trial_ids, i)
    # adding raw data to df_excluded_raw
    df_excluded_raw <- rbind(df_excluded_raw, df_breathing_cycle)
  }
}

# saving all cut trials for later visual inspection
df_combined <- rbind(df_included_raw, df_excluded_raw)

# saving excluded trial ids
excluded_maximum_trial_ids <- unique(df_included_meta$Trial_ID)

# applying the maximum criterion
# (determining the trial with the highest included vc for every ID)
df_included_meta <- df_included_meta %>%
  group_by(ID) %>%
  summarise(
    Trial_ID = Trial_ID[which.max(VC)],
    VC = max(VC)
  )

# removing included trials from vector and 
excluded_maximum_trial_ids <- excluded_maximum_trial_ids[!(excluded_maximum_trial_ids %in% df_included_meta$Trial_ID)]

# reducing raw data to only included trials
df_included_raw <- inner_join(df_included_raw, df_included_meta, by = c("ID", "Trial_ID"))
df_included_raw$VC <- NULL

# creating Volume-Time-Diagrams for visual inspection
for (i in unique(df_combined$Trial_ID)) {
  df_trial <- df_combined[df_combined$Trial_ID == i,]
  df_trial <- na.omit(df_trial)
  
  # calculating statistics
  vexmax <- max(df_trial$Volume)
  vexmin <- df_trial$Volume[1]
  vinmin <- df_trial$Volume[nrow(df_trial)]
  fevc <- vexmax - vexmin
  fivc <- vexmax - vinmin
  diff <- abs(fevc - fivc)
  vc <- max(c(fevc, fivc))
      
  # preparing file path
  file_path <- NULL
  trial_id <- df_trial$Trial_ID[1]
  id <- df_trial$ID[1]
  visit <- df_trial$Visit[1]
  trial <- df_trial$Trial[1]
  if (trial_id %in% excluded_maximum_trial_ids) {
    file_path <- paste0("diagrams/excluded_maximum_trials/",id,"_",visit,"_",trial,".png")
  } else if (trial_id %in% excluded_completeness_trial_ids) {
    file_path <- paste0("diagrams/excluded_completeness_trials/",id,"_",visit,"_",trial,".png")
  } else {
    file_path <- paste0("diagrams/included_trials/",id,"_",visit,"_",trial,".png")
  }
  
  # creating Volume-Time-Diagrams for visual inspection
  ggplot(df_trial, aes(x = Time, y = Volume)) +
    geom_path(size = 1, color = "#36648B") +
    annotate("text", x = max(df_trial$Time)/2, y = 1.1, label = paste0("VC = ", round(vc*1000,0), " ml"), color = "black", size = 4.5) +
    annotate("text", x = max(df_trial$Time)/2, y = 0.8, label = paste0("0.05 * VC = ", round(0.05*vc*1000), " ml"), color = "black", size = 4.5) +
    annotate("text", x = max(df_trial$Time)/2, y = 0.5, label = paste0("|FEVC - FIVC| = ", round(diff*1000,0), " ml"), color = "black", size = 4.5) +
    xlab("Time [s]") +
    ylab("Volume [l]") +
    ggtitle(paste0("ID = ", id,", Visit = ", visit,", Trial = ", trial)) +
    theme_classic() +
    theme(legend.position = "none",
          plot.title = element_text(color="black", size=17, hjust = 0.5),
          axis.title.x = element_text(color="black", size=14),
          axis.title.y = element_text(color="black", size=14),
          axis.text.x = element_text(size=12, angle = 0),
          axis.text.y = element_text(size=12),
          panel.grid.major = element_line(colour = "grey93", linetype = "solid"),
          panel.grid.minor = element_line(colour = "grey93", linetype = "dotted")
    )
  ggsave(file_path, width = 7, height = 6)
}

# printing amount of excluded and included trials
print(paste0("MBDS Trials: ", length(unique(df_mbds$Trial_ID))))
print(paste0("Excluded Trials (Completeness criterion): ", length(excluded_completeness_trial_ids)))
print(paste0("Excluded Trials (Maximum criterion): ", length(excluded_maximum_trial_ids)))
print(paste0("Included Trials: ", nrow(df_included_meta)))

# save df_included_raw as fmbds
df_included_raw$Trial_ID <- NULL
write.csv(df_included_raw, "fmbds/fmbds.csv", row.names=FALSE)
