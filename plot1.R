library(dplyr)
library(ggplot2)

getwd()
setwd("C:/Users/bhogan/Documents/R")

download_data = function() {
	### Create directory
	if(!file.exists("edacp")) {
	dir.create("edacp")
	}
	setwd("./edacp")

	### Download and unzip data
	fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
	message("Downloading data")
	download.file(fileUrl, destfile = "FNEI_data.zip")
	unzip("FNEI_data.zip")
	
	### Note date file downloaded
	dateDownloaded = date()
}

download_data()

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


###### Plot 1
annual <- NEI %>%
  group_by(year) %>%
  summarize(total = sum(Emissions))

years <- as.character(annual$year)

png("plot1.png", 480, 480)
barplot(annual$total, names.arg=years, xlab="Year", ylab="PM2.5 Emitted, in Tons")
title(main = "That's a lot of PM2.5", font.main = 4)
dev.off()
