co2_data <- read.csv("D:/UM Master/Sem 1/Principle of data science/Group Project/CO2 emission by countries.csv", 
                     header = TRUE, 
                     sep = ",",
                     encoding = "UTF-8")

co2_data <- as.data.frame(co2_data)
View(co2_data)

summary(co2_data)
head(co2_data)

boxplot(co2_data)
is.empty(co2_data)

null_value_index <- which(is.na(co2_data$Country)|co2_data$Country == "")
null_value_index

sum(is.na(co2_data$Country)|co2_data$Country == "")

# Print to check number of empty value in a dataset
print.numOfEmtpyValue <- function(data) {
  # create empty matrix
  df <- data.frame(matrix(ncol = 2, nrow = 0))
  
  for(i in 1:ncol(data)) {
    df[nrow(df) + 1,] <- c(colnames(data)[i], sum(is.na(data[, i])|data[, i] == ""))
  }
  print(df)
}

print.numOfEmtpyValue(co2_data)

colnames(co2_data)[1]
names(co2_data)[1]

