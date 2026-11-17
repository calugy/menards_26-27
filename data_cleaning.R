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

#INCOME CLEANING----------------------------------------------------------------
income <- read_excel(
  "C:/Users/Owner/Downloads/Menards 26-27/01_data_raw/income_raw/income_english_raw.xlsx"
                     , sheet = 2)

income <- income[-(1:6),]
income <- income[-(110:113),]

income[[3]] <- as.numeric(income[[3]])
month <- 1
for (n in 2:109){
  income[n,3] <- month
  month <- month + 1
  if (month == 13){
    month <- 1
    
  }
}

income[[1]] <- as.numeric(income[[1]])
for (n in 2:109){
  if (income[n,3] == 1){
    year <- income[n,1]
  }
  income[n,1] <- year
}

colnames(income) <- income[1,]
income <- income[-1,]
income <- income[,-2]
colnames(income)[1:2] <- c("year", "month")

income$year <- as.numeric(income$year)
income$month <- as.numeric(income$month)

income$date <- as.Date(
  paste(income$year, income$month, 1, sep = "-"),
  format = "%Y-%m-%d"
)

income <- income[,-(1:2)]

income <- income[, c("date", setdiff(names(income), "date"))]

income <- t(income)

colnames(income) <- paste(income[1,], "income", sep = "_")

income <- income[-1,]

write.csv(income, row.names = TRUE,
    "C:/Users/Owner/Downloads/Menards 26-27/02_data_clean/income_clean.csv")

#CPI CLEANING-------------------------------------------------------------------
cpi <- read_excel(sheet = 2,
  "C:/Users/Owner/Downloads/Menards 26-27/01_data_raw/cpi_raw/cpi_english_raw.xlsx")

cpi <- cpi[-(1:6),]
cpi <- cpi[-(50:53),]

cpi[[3]] <- as.numeric(cpi[[3]])
month <- 1
for (n in 2:49){
  cpi[n,3] <- month
  month <- month + 1
  if (month == 13){
    month <- 1

  }
}

cpi[[1]] <- as.numeric(cpi[[1]])
for (n in 2:49){
  if (cpi[n,3] == 1){
    year <- cpi[n,1]
  }
  cpi[n,1] <- year
}

colnames(cpi) <- cpi[1,]
cpi <- cpi[-1,]
cpi <- cpi[,-2]
colnames(cpi)[1:2] <- c("year", "month")

cpi$year <- as.numeric(cpi$year)
income$month <- as.numeric(cpi$month)

cpi$date <- as.Date(
  paste(cpi$year, cpi$month, 1, sep = "-"),
  format = "%Y-%m-%d"
)

cpi <- cpi[,-(1:2)]

cpi <- cpi[, c("date", setdiff(names(cpi), "date"))]

cpi <- t(cpi)

colnames(cpi) <- paste(cpi[1,], "cpi", sep = "_")

cpi <- cpi[-1,]

write.csv(cpi, row.names = TRUE,
          "C:/Users/Owner/Downloads/Menards 26-27/02_data_clean/cpi_clean.csv")
