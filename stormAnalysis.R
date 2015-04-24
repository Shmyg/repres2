# Initialization section
Sys.setlocale('LC_ALL', 'en_US.UTF8')
url <- 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2'
zipFile <- 'repdata-data-StormData.csv.bz2'

# Reaging and parsing the file
# Checking if the file has already been downloaded
if (!file.exists(zipFile)) {
 # Not yet
 download.file (url, zipFile, method = 'curl')
} else {
 # Dirty job was already done
 message( 'The file has already been downloaded, skipping')
}

data <- read.csv(bzfile(zipFile))
library('dplyr')
events <- group_by (data, EVTYPE)
totalData <- summarize (events, Fatality = sum(FATALITIES), Injury = sum(INJURIES))
fd <- head(totalData[order(-totalData$Fatalities, -totalData$Injuries),], 10)
fdLong <- melt(fd, id.vars=c("EVTYPE"), variable.name='Type')
g <- ggplot(data=fdLong, aes(x=reorder(EVTYPE, -value), y=value, fill=Type)) +
	geom_bar(stat="identity") +
	ggtitle("Top 10 weather events casuing fatalities/injuries") +
	xlab("Event type") +
	ylab("Total number of fatalities/injuries") +
	theme (axis.text.x = element_text(angle=90, vjust=1))
