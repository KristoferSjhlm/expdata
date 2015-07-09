print("Downloading and unzipping the data.")

## download and unzip the data
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data.zip", method="curl")
unzip("data.zip", files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, exdir ="./", unzip = "internal", setTimes = FALSE)

print("Reading the data in to a data frame.")
# read the data
rawdata <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, blank.lines.skip = TRUE, na.strings = "?")

print("Put the date and time together and filter the data.")
# adds a new datetime column where they are in the same correct data/time class
powerconsumptiondata <- mutate(rawdata, datetime = dmy(Date) + hms(Time))
# add an new column with just date for filtering
powerconsumptiondata <- mutate(powerconsumptiondata, newdate = dmy(Date))
# filter on the dates we want
powerconsumptiondata <- filter(powerconsumptiondata, newdate >= "2007-02-01" & newdate < "2007-02-03")

print("Print the data to a png-file in the working directory.")
# open the png graphic device
png(filename = "plot3.png", width = 480, height = 480, units = "px")

with(powerconsumptiondata, plot(datetime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab= ""))
with(powerconsumptiondata, lines(datetime, Sub_metering_2, type = "l", col = "red"))
with(powerconsumptiondata, lines(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright",col=c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1)

# close the graphic device
dev.off()

print("Done!")
