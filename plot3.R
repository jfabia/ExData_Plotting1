# Load the required libraries
library(data.table)

# Remove current variables in working environment
rm(list=ls())
# Reset the plot margins
par(mfrow = c(1,1))

# Read the data for this project. 
# If it is not available in the working directory, 
# check if the original zip file name is in the working directory
# If it is available, unzip the file.
# If that isn't available, then download the file then unzip.

if(!file.exists("./household_power_consumption.txt")){
        if(!file.exists("./exdata%2Fdata%2Fhousehold_power_consumption.zip")){
                fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                download.file(fileURL, destfile = "./exdata%2Fdata%2Fhousehold_power_consumption.zip")
        }
        unzip("./exdata%2Fdata%2Fhousehold_power_consumption.zip")
}

# Read the data with all columns treated as character class
power.data <- read.table("./household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE, dec = ".")

# Since '?' are treated as missing values, replace them with NA
power.data[ power.data == "?"] <- NA

# Transform the Date column as a Date class
power.data$Date <- as.Date(power.data$Date, "%d/%m/%Y")
power.data <- 
        subset(power.data, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

# Create a new column, Timestamp, that records both the date and the time.
power.data$Timestamp <- as.POSIXct(paste(power.data$Date, power.data$Time))

# Transform the columns as numeric class
for(i in 1:10){
        if(!(names(power.data)[i] %in% c("Date","Time", "Timestamp"))){
                power.data[,i] <- as.numeric((power.data[,i]))
        }
}

# Create a plot of time vs. sub-meterings 1 through 3, and print it as a PNG file.
png('plot3.png', width = 480, height = 480, bg='white')
plot(power.data$Timestamp, power.data$Sub_metering_1, type = 'l', xlab = "", ylab = "Energy sub metering")
lines(power.data$Timestamp, power.data$Sub_metering_2, col = 'red')
lines(power.data$Timestamp, power.data$Sub_metering_3, col = 'blue')
legend('topright', legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lwd=2.5, lty = 1)
dev.off()

# Return to default margins
par(mfrow = c(1,1))
