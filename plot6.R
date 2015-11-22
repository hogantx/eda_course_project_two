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

###### Plot 6
### Reduce SCC table to only necessary variables for merge
tmp <- SCC %>%
  select(SCC,  EI.Sector)

### Merge EI.Sector to NEI
NEI <- merge(NEI, tmp, by="SCC")

balt_la_mv <- NEI %>%
  filter(EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles" |
	EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" |
	EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles" |
	EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles" ) %>%
  filter(fips == "24510" | fips == "06037") %>%
  group_by(fips, year) %>%
  summarize(total = sum(Emissions))

balt_la_mv$fips <- ifelse(balt_la_mv$fips == "24510", "Baltimore", "Los Angeles")
years <- as.character(baltimore_mv$year)

### Plotty plot
png("plot6.png", 480, 480)
ggplot(balt_la_mv, aes(factor(year), total, fill=fips)) +
  geom_bar(stat="identity") +
  facet_grid(fips ~ ., scale="free") +
  xlab("Year") + ylab("Total Motor Vehicle PM25 Emissions")
dev.off()


