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


###### Plot 3

### Set image dimension
dev.new(width=10, height=5)

head(NEI)
Baltimore_2 <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarize(total = sum(Emissions))

head(Baltimore_2)

png("plot3.png", 480, 480)
ggplot(Baltimore_2, aes(factor(year), total, fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(type ~ ., scale="free") +
  xlab("Year") + ylab("PM2.5 Emitted, in Tons") +
  theme(axis.text.x = element_text(size=9, angle=0))+ 
  theme(axis.text.y = element_text(size=9))
dev.off()
