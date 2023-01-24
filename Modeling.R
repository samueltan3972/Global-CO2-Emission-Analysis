install.packages('forecast')
library(forecast)

# Set to current working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

co2_emission <- read.csv("Actual_CO2.csv")

# To get global CO2 Emission and convert into time series object
accumulated_co2_by_year <- aggregate(CO2.emission ~ Year, data = co2_emission, sum)
annualized_co2_by_year <- aggregate(Actual_CO2_by_year ~ Year, data = co2_emission, sum)

# Convert the data into time series object
accumulated_co2_time_series = ts(accumulated_co2_by_year$CO2.emission, start=1750) 
accumulated_co2_time_series

annualized_co2_time_series = ts(annualized_co2_by_year$Actual_CO2_by_year, start=1750) 
annualized_co2_time_series

plot(accumulated_co2_time_series)
plot(annualized_co2_time_series)

# ddata <- decompose(annualized_co2_time_series)
# plot(ddata)

# 1. Linear Regression 
accumulated_linear_model = tslm(accumulated_co2_time_series ~ trend)
accumulated_linear_predicted = forecast(accumulated_linear_model, h = 30)
accumulated_linear_predicted

annualized_linear_model = tslm(annualized_co2_time_series ~ trend)
annualized_linear_predicted = forecast(annualized_linear_model, h = 30)
annualized_linear_predicted

# 1.2 Model Evaluation
accuracy(accumulated_linear_predicted)
summary(accumulated_linear_model)
checkresiduals(accumulated_linear_model) 
plot(accumulated_linear_predicted)

accuracy(annualized_linear_predicted)
summary(annualized_linear_model)
checkresiduals(annualized_linear_model) 
plot(annualized_linear_predicted)



# 2. ARIMA
accumulated_arima_model = auto.arima(accumulated_co2_time_series)
accumulated_arima_predicted = forecast(accumulated_arima_model, h = 30)
accumulated_arima_predicted

annualized_arima_model = auto.arima(annualized_co2_time_series)
annualized_arima_predicted = forecast(annualized_arima_model, h = 30)
annualized_arima_predicted

# 2.2 Model Evaluation
accuracy(accumulated_arima_predicted)
summary(accumulated_arima_model)
checkresiduals(accumulated_arima_model) 
plot(accumulated_arima_predicted)

accuracy(annualized_arima_predicted)
summary(annualized_arima_model)
checkresiduals(annualized_arima_model) 
plot(annualized_arima_predicted)



# 3. Naive Forecasting Method
accumulated_naive_model = naive(accumulated_co2_time_series, h = 30)
annualized_naive_model = naive(annualized_co2_time_series, h = 30)

# 3.2 Model Evaluation
accuracy(accumulated_naive_model)
summary(accumulated_naive_model)
checkresiduals(accumulated_naive_model) 
plot(accumulated_naive_model)

accuracy(annualized_naive_model)
summary(annualized_naive_model)
checkresiduals(annualized_naive_model) 
plot(annualized_naive_model)



# 4. TBATS
accumulated_tbats_model = auto.arima(accumulated_co2_time_series)
accumulated_tbats_predicted = forecast(accumulated_tbats_model, h = 30)
accumulated_tbats_predicted

annualized_tbats_model = auto.arima(annualized_co2_time_series)
annualized_tbats_predicted = forecast(annualized_tbats_model, h = 30)
annualized_tbats_predicted

# 4.2 Model Evaluation
accuracy(accumulated_tbats_predicted)
summary(accumulated_tbats_model)
checkresiduals(accumulated_tbats_model) 
plot(accumulated_tbats_predicted)

accuracy(annualized_tbats_predicted)
summary(annualized_tbats_model)
checkresiduals(annualized_tbats_model) 
plot(annualized_tbats_predicted)


# 5. Holt's Method
accumulated_holt_model = holt(accumulated_co2_time_series, h = 30)
annualized_holt_model = holt(annualized_co2_time_series, h = 30)

# 3.2 Model Evaluation
accuracy(accumulated_holt_model)
summary(accumulated_holt_model)
checkresiduals(accumulated_holt_model) 
plot(accumulated_holt_model)

accuracy(annualized_holt_model)
summary(annualized_holt_model)
checkresiduals(annualized_holt_model) 
plot(annualized_holt_model)
