library(dplyr)

# loading the dataset
df_fmbds <- read.csv("fmbds/fmbds.csv", sep = ",")
df_mbds_meta <- read.csv("mbds/demographics_data.csv", sep = ",")

# initiating dataframe for the RefMBDS-meta
df_refmbds_meta <- data.frame(ID_old = numeric(),
                              ID = numeric(),
                              VC = numeric(),
                              VC_percentile = numeric(),
                              PEF = numeric(),
                              PEF_percentile = numeric(),
                              PIF = numeric(),
                              PIF_percentile = numeric(),
                              Weight = numeric(),
                              Height = numeric(),
                              Sex = character(),
                              Age = numeric(),
                              Ethnicity = character(),
                              Race = character())
id_counter <- 0

# loop through every id/trial and filling df_refmbds_meta
for (i in unique(df_fmbds$ID)) {
  df_id <- df_fmbds[df_fmbds$ID == i,]
  
  # calculating VC, PEF and PIF (rounding on 3 decimals)
  vexmax <- max(df_id$Volume)
  vexmin <- df_id$Volume[1]
  vinmin <- df_id$Volume[nrow(df_id)]
  fevc <- vexmax - vexmin
  fivc <- vexmax - vinmin
  vc <- round(max(c(fevc, fivc)), 3)
  pef <- round(max(df_id$Flow), 3)
  pif <- round(min(df_id$Flow), 3)
  
  # creating new row
  id_counter <- id_counter + 1
  index <- which(df_mbds_meta$ID == i)
  meta_data <- data.frame(ID_old = i,
                          ID = id_counter,
                          VC = vc,
                          VC_percentile = NA,
                          PEF = pef,
                          PEF_percentile = NA,
                          PIF = pif,
                          PIF_percentile = NA,
                          Weight = df_mbds_meta$WEIGHT[index],
                          Height = df_mbds_meta$HEIGHT[index],
                          Sex = df_mbds_meta$SEX[index],
                          Age = df_mbds_meta$AGE[index],
                          Ethnicity = df_mbds_meta$ETHNICITY[index],
                          Race = df_mbds_meta$RACE[index])
  
  # adding row to df_refmbds_meta
  df_refmbds_meta <- rbind(df_refmbds_meta, meta_data)
}

# calculating PEF percentiles
df_refmbds_meta <- df_refmbds_meta %>%
  arrange(PEF)
for (i in 1:nrow(df_refmbds_meta)) {
  df_refmbds_meta$PEF_percentile[i] <- round(i/nrow(df_refmbds_meta)*100, 1)
}

# calculating PIF percentiles
df_refmbds_meta <- df_refmbds_meta %>%
  arrange(desc(PIF))
for (i in 1:nrow(df_refmbds_meta)) {
  df_refmbds_meta$PIF_percentile[i] <- round(i/nrow(df_refmbds_meta)*100, 1)
}

# calculating VC percentiles
df_refmbds_meta <- df_refmbds_meta %>%
  arrange(VC)
for (i in 1:nrow(df_refmbds_meta)) {
  df_refmbds_meta$VC_percentile[i] <- round(i/nrow(df_refmbds_meta)*100, 1)
}

# preparing RefMBDS-raw with the new IDs
df_refmbds_raw <- df_fmbds
df_refmbds_raw$Visit <- NULL
df_refmbds_raw$Trial <- NULL
for (i in 1:nrow(df_refmbds_raw)) {
  df_refmbds_raw$ID[i] <- df_refmbds_meta$ID[df_refmbds_meta$ID_old == df_refmbds_raw$ID[i]]
}

# remove ID_old from df_refmbds_meta and sort by ID
df_refmbds_meta$ID_old <- NULL
df_refmbds_meta <- df_refmbds_meta %>%
  arrange(ID)

# save RefMBDS
write.csv(df_refmbds_raw, "refmbds/refmbds_raw.csv", row.names=FALSE)
write.csv(df_refmbds_meta, "refmbds/refmbds_meta.csv", row.names=FALSE)
