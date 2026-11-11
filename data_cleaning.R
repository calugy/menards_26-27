library(readxl)

#ROAD DENSITY CLEANING---------------------------------------------------------

rd_density_raw <- read_excel(
  "C:/Users/Owner/Downloads/Menards 26-27/01_data_raw/road_density_raw.xlsx")

colnames(rd_density_raw) <- as.character(rd_density_raw[3,])

rd_density_raw <- rd_density_raw[-(1:3),]
rd_density_raw <- rd_density_raw[-(100:106),]

#delete sub-regions

strike_1 <- c()

for (n in 1:99) {
  if (rd_density_raw[n,2] == "Of which (sub-unit)") {
    strike_1 <- c(strike_1, n)
  }
}

rd_density_raw <- rd_density_raw[-strike_1, ]

#assign economic regions 

strike_2 <- c()
econ_region <- c("NATIONAL")

for (n in 2:90){
  if (rd_density_raw[n,2] == "Economic region"){
    strike_2 <- c(strike_2, n)
    region <- rd_density_raw[n,1]
  }

  econ_region <- c(econ_region, region)
}

rd_density_raw$econ_region <- econ_region

rd_density_raw <- rd_density_raw[rd_density_raw$Level == "Region",]

rd_density_raw[] <- lapply(rd_density_raw, function(x) {
  if (is.list(x)) unlist(x) else x
})

rd_density_raw <- rd_density_raw[,-2]

write.csv(rd_density_raw, 
          "C:/Users/Owner/Downloads/Menards 26-27/02_data_clean/road_density_clean.csv",
          row.names = FALSE)

#CRIME RATE CLEANING------------------------------------------------------------
crime <- read_excel(
  "C:/Users/Owner/Downloads/Menards 26-27/01_data_raw/crime_rate_raw.xlsx",
  sheet = 2)

crime <- crime[-1,-15]

write.csv(rd_density_raw, 
          "C:/Users/Owner/Downloads/Menards 26-27/02_data_clean/crime_rate_clean.csv",
          row.names = FALSE)

#
