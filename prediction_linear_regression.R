library(Metrics)
library(ggplot2)

# First, read in the data and view it
co2_emission <- read.csv("co2_emission.csv")

# Next, group the data by year and sum the CO2.emission column
co2_by_year <- aggregate(CO2.emission ~ Year, data = co2_emission, sum)

# Now split the data into our training and test sets
train_set <- co2_by_year[co2_by_year$Year <= 1966, ]
test_set <- co2_by_year[co2_by_year$Year > 1966, ]

# Finally, check the dimensions of our training and test sets to make sure they are correct # nolint
dim(train_set)
dim(test_set)

# Now that we have our training and test sets, we can build our regression model using the lm() function
model <- lm(CO2.emission ~ Year, data = train_set)

# To make predictions using our model, use the predict() function
predictions <- predict(model, test_set)

# To evaluate the performance of our model, calculate the mean squared error (MSE) and root mean squared error (RMSE) using the mse() and rmse() functions from the forecast package
MSE <- mse(predictions, test_set$CO2.emission)
RMSE <- rmse(predictions, test_set$CO2.emission)

# Finally, calculate the accuracy of our model as a percentage by dividing the sum of correct predictions by the total number of predictions and multiplying by 100
accuracy <- 100 * sum(predictions == test_set$CO2.emission) / length(predictions)
prediction_2050 <- predict(model, data.frame(Year = 2050))

# First, create a data frame with the predictions and actual values
prediction_df <- rbind(prediction_df, data.frame(Year = 2050, Prediction = prediction_2050, Actual = NA))

# Next, plot the predictions and actual values using ggplot2
plot_prediction <- ggplot(prediction_df, aes(x = Year)) +
    geom_point(aes(y = Prediction), color = "blue") +
    geom_point(aes(y = Actual), color = "red") +
    geom_line(aes(y = Prediction), color = "blue") +
    geom_line(aes(y = Actual), color = "red") +
    labs(
        title = "Prediction vs. Actual CO2 Emission",
        x = "Year",
        y = "CO2 Emission"
    )

# Add the prediction for 2050 to the plot
plot_prediction_2050 <- ggplot(prediction_df, aes(x = Year)) +
    geom_point(aes(y = Prediction), color = "blue") +
    geom_point(aes(y = Actual), color = "red") +
    geom_point(aes(y = prediction_2050), color = "green") +
    geom_line(aes(y = prediction_2050), color = "green") +
    geom_line(aes(y = Prediction), color = "blue") +
    geom_line(aes(y = Actual), color = "red") +
    geom_vline(xintercept = 2050, color = "green") +
    labs(
        title = "Prediction vs. Actual CO2 Emission",
        x = "Year",
        y = "CO2 Emission"
    )

plot_prediction_2050
