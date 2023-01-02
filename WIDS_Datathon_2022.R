library(mice)
library(dplyr)
library(tidyr)

### Data Preparation ###

# Load the data
data <- read.csv('train.csv')

# Transform the data 
str(data)

data$State_Factor <- as.factor(data$State_Factor)
data$building_class <- as.factor(data$building_class)
data$facility_type <- as.factor(data$facility_type)


### Explanatory Analysis ###

summary(data$Year_Factor)
boxplot(data$Year_Factor)


### Data Cleaning ###

# Check the NA values
colSums(is.na(data))

# Delete NA in Year_built
data <- drop_na(data, year_built)

### Replace the NA in days_with_fog by the mean of each corresponding state ###

# Calculate the mean 
fog_data = data %>% group_by(State_Factor) %>% summarise(avg=mean(days_with_fog,na.rm=TRUE))

# Replace the NA by the mean
data$days_with_fog[data$State_Factor == 'State_1' & is.na(data$days_with_fog)] = 89
data$days_with_fog[data$State_Factor == 'State_2' & is.na(data$days_with_fog)] = 108
data$days_with_fog[data$State_Factor == 'State_4' & is.na(data$days_with_fog)] = 194
data$days_with_fog[data$State_Factor == 'State_6' & is.na(data$days_with_fog)] = 100
data$days_with_fog[data$State_Factor == 'State_8' & is.na(data$days_with_fog)] = 91
data$days_with_fog[data$State_Factor == 'State_10' & is.na(data$days_with_fog)] = 93
data$days_with_fog[data$State_Factor == 'State_11' & is.na(data$days_with_fog)] = 261


### Replace the NA in direction_max_wind_speed by the mean of each corresponding state ###

# Calculate the mean 
max_wind_speed_data = data %>% group_by(State_Factor) %>% summarise(avg=mean(direction_max_wind_speed,na.rm=TRUE))

# Replace the NA by the mean
data$direction_max_wind_speed[data$State_Factor == 'State_1' & is.na(data$direction_max_wind_speed)] = 22
data$direction_max_wind_speed[data$State_Factor == 'State_2' & is.na(data$direction_max_wind_speed)] = 1
data$direction_max_wind_speed[data$State_Factor == 'State_4' & is.na(data$direction_max_wind_speed)] = 253
data$direction_max_wind_speed[data$State_Factor == 'State_6' & is.na(data$direction_max_wind_speed)] = 64
data$direction_max_wind_speed[data$State_Factor == 'State_8' & is.na(data$direction_max_wind_speed)] = 132
data$direction_max_wind_speed[data$State_Factor == 'State_10' & is.na(data$direction_max_wind_speed)] = 226
data$direction_max_wind_speed[data$State_Factor == 'State_11' & is.na(data$direction_max_wind_speed)] = 1

### Replace the NA in direction_peak_wind_speed by the mean of each corresponding state ###

# Calculate the mean 
peak_wind_speed_data = data %>% group_by(State_Factor) %>% summarise(avg=mean(direction_peak_wind_speed,na.rm=TRUE))

# Replace the NA by the mean
data$direction_peak_wind_speed[data$State_Factor == 'State_1' & is.na(data$direction_peak_wind_speed)] = 19
data$direction_peak_wind_speed[data$State_Factor == 'State_2' & is.na(data$direction_peak_wind_speed)] = 1
data$direction_peak_wind_speed[data$State_Factor == 'State_4' & is.na(data$direction_peak_wind_speed)] = 261
data$direction_peak_wind_speed[data$State_Factor == 'State_6' & is.na(data$direction_peak_wind_speed)] = 59
data$direction_peak_wind_speed[data$State_Factor == 'State_8' & is.na(data$direction_peak_wind_speed)] = 137
data$direction_peak_wind_speed[data$State_Factor == 'State_10' & is.na(data$direction_peak_wind_speed)] = 215
data$direction_peak_wind_speed[data$State_Factor == 'State_11' & is.na(data$direction_peak_wind_speed)] = 1

### Replace the NA in max_wind_speed by the mean of each corresponding state ###

# Calculate the mean 
max_wind_data = data %>% group_by(State_Factor) %>% summarise(avg=mean(max_wind_speed,na.rm=TRUE))

# Replace the NA by the mean
data$max_wind_speed[data$State_Factor == 'State_1' & is.na(data$max_wind_speed)] = 1.54
data$max_wind_speed[data$State_Factor == 'State_2' & is.na(data$max_wind_speed)] = 1.00
data$max_wind_speed[data$State_Factor == 'State_4' & is.na(data$max_wind_speed)] = 13.60
data$max_wind_speed[data$State_Factor == 'State_6' & is.na(data$max_wind_speed)] = 4.11
data$max_wind_speed[data$State_Factor == 'State_8' & is.na(data$max_wind_speed)] = 7.71
data$max_wind_speed[data$State_Factor == 'State_10' & is.na(data$max_wind_speed)] = 12.96
data$max_wind_speed[data$State_Factor == 'State_11' & is.na(data$max_wind_speed)] = 1.00


### Outliers ###

# Delete rows with year 0 in in year_built (Only 6)
data <- subset(data, data$year_built != 0)

### Imputation method with mice for NA values in energy star rating without using the output variable###

data_imp1 = data[,c(1,2,3,4,5,6,7,8)]
summary(data_imp1)


imp = mice(data_imp1,m=5,method='cart',maxit=20)
data_energy_star = complete(imp)
colSums(is.na(data_energy_star))

data$energy_star_rating = data_energy_star$energy_star_rating

data_final = data

### Data Enrichment ###


#Create a unique ID for the similar buildings 
#ID with the values (char) separated by _ ###

data_final$ID_char = paste0(data_final$State_Factor, "_", data_final$building_class, "_", 
                            data_final$facility_type, "_", data_final$floor_area, "_", data_final$year_built)

### Determine how many occurrences we have for each unique building
data_final = data_final %>% group_by(ID_char) %>% mutate(Count_Years = length(id))

### Creating the final ID as a number
data_final$ID_Building = as.numeric(as.factor(data_final$ID_char))
data_final <- data_final[order(data_final$Count_Years),]


### Splitting the dataset

### I exclude building with only 1 and 2 observation. 


train1 = data_final[c(1:18286),] # 24% of data set
rest = data_final[c(18286:73914),]


row.number = sample(1:nrow(rest), 0.5*nrow(rest))
train2 = rest[row.number,]
data_enrich = rest[-row.number, ]
dim(train2)
dim(data_enrich)

train = rbind(train1, train2)


### Create a Test Sample without the result of consumption

data_enrich1 = data_enrich
data_enrich1$site_eui = NA

### I want to add the mean of the consumption of the similar type of building to our data_enrich1 dataset.

total = rbind(train, data_enrich1)

## Add mean consumption of each building ID 
record_consumption = lags = total %>% group_by(ID_Building, Year_Factor) %>% summarize(mean_site_eui = mean(site_eui, na.rm = TRUE))

record_consumption = lags %>% group_by(ID_Building) %>% mutate(mean_previous_eui = mean(mean_site_eui, na.rm = T))


### Add the average consumption by matching the two data frame
data_enrich$consumption_building_type <- record_consumption$mean_previous_eui[match(data_enrich1$ID_Building, record_consumption$ID_Building)]
train$consumption_building_type <- record_consumption$mean_previous_eui[match(train$ID_Building, record_consumption$ID_Building)]


data_enrich <- drop_na(data_enrich, consumption_building_type)
colSums(is.na(data_enrich))

### Best Model
row.number = sample(1:nrow(data_enrich), 0.8*nrow(data_enrich))
final_train = data_enrich[row.number,]
final_test = data_enrich[-row.number, ]
 colSums(is.na(final_train))
 

#Estimate the model on the training set
model=lm(site_eui~ consumption_building_type + energy_star_rating + max_wind_speed + days_with_fog,final_train)
summary(model)
par(mfrow=c(2,2))
plot(model)

# Compute prediction error, RMSE, MAPE
pred0.8 = predict(model,final_test)
err0.8 = pred0.8 - final_test$site_eui
rmse = sqrt(mean(err0.8^2))
mape = mean(abs(err0.8/final_test$site_eui))
rmse
mape


# Normality of residuals
# QQ plot
qqnorm(residuals(model))
qqline(residuals(model)) #close to the line, the closer it is to a normal distribution
# Shape of the residuals
# Indicator of normality but it focuses on whether there are a lot of extreme values compared to the benchmark of normal dist. 

plot(predict(model), residuals(model))
plot(predict(model), rstudent(model))
abline(a=2,b=0,col='red')
abline(a=-2,b=0,col='red')







