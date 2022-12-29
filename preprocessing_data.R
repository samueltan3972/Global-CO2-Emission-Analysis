# First, read in the data and view it
co2_emission <- read.csv("Actual_CO2.csv")
View(co2_emission)

# Next, group the data by year and sum the CO2.emission column
co2_by_year <- aggregate(CO2.emission ~ Year, data = co2_emission, sum)

# Now split the data into our training and test sets
train_set <- co2_by_year[co2_by_year$Year <= 1966, ]
test_set <- co2_by_year[co2_by_year$Year > 1966, ]

# Finally, check the dimensions of our training and test sets to make sure they are correct # nolint
dim(train_set)
dim(test_set)

# View dimensions data
View(train_set)
View(test_set)
