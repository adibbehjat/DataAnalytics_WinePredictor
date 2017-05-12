wine_data <- read.csv("data/winequality.csv")
wine_sub <- subset(wine_data, wine == "W")
wine_sub <- wine_data
wine.null <- lm(quality ~ 1, data = wine_sub)
wine.step <- step(wine.null, scope = .~. + pH * fixed.acidity * volatile.acidity * citric.acid + residual.sugar + chlorides + free.sulfur.dioxide * total.sulfur.dioxide * sulphates + density * alcohol)
print(summary(wine.step))
model <- wine.step$call
# 
# # RANDOM DATA GENERATOR
# # DAMN SON WHERE YOU FIND THAT!
# fixed.acidity.val = (sample((min(wine_sub$fixed.acidity) * 1000.0):(max(wine_sub$fixed.acidity) * 1000.0), 1))/1000.0
# 
# volatile.acidity.val = (sample((min(wine_sub$volatile.acidity) * 1000.0):(max(wine_sub$volatile.acidity) * 1000.0), 1))/1000.0
# 
# citric.acid.val = (sample((min(wine_sub$citric.acid) * 1000.0):(max(wine_sub$citric.acid) * 1000.0), 1))/1000.0
# residual.sugar.val = (sample((min(wine_sub$residual.sugar) * 1000.0):(max(wine_sub$residual.sugar) * 1000.0), 1))/1000.0
# chlorides.val = (sample((min(wine_sub$chlorides) * 1000.0):(max(wine_sub$chlorides) * 1000.0), 1))/1000.0
# free.sulfur.dioxide.val = (sample((min(wine_sub$free.sulfur.dioxide) * 1000.0):(max(wine_sub$free.sulfur.dioxide) * 1000.0), 1))/1000.0
# total.sulfur.dioxide.val = (sample((min(wine_sub$total.sulfur.dioxide) * 1000.0):(max(wine_sub$total.sulfur.dioxide) * 1000.0), 1))/1000.0
# density.val = (sample((min(wine_sub$density) * 1000.0):(max(wine_sub$density) * 1000.0), 1))/1000.0
# pH.val = (sample((min(wine_sub$pH) * 1000.0):(max(wine_sub$pH) * 1000.0), 1))/1000.0
# sulphates.val = (sample((min(wine_sub$sulphates) * 1000.0):(max(wine_sub$sulphates) * 1000.0), 1))/1000.0
# alcohol.val = (sample((min(wine_sub$alcohol) * 1000.0):(max(wine_sub$alcohol) * 1000.0), 1))/1000.0
# 
# # Evaluate this ridiculously complicated expression based on the provided terms
# 
# # The process involves:
# # Pasting the information -> concatenates all expressions to string
# # Parse the information -> Parse the text into R code
# # Evaluate the parsed information -> run that thing, baby!
# 
# # Empty string to create the dataframe
# df = ""
# 
# # Loop through the selected variables for the loop
# for (i in 3:length(attr(wine.step$terms,"variables"))) {
#   
#   # Collect variable name
#   var_name <- attr(wine.step$terms,"variables")[[i]]
#   
#   # Feed the data frame
#   df <- paste(df,var_name,"=c(",var_name,".val)", sep = "")
#   
#   # Need commas ya'know
#   if (i != length(attr(wine.step$terms,"variables"))) {
#     df <- paste(df,",")
#   }
#   
# }
# 
# # Wrap for data.frame
# df <- paste("data.frame(",df,")", sep = "")
# 
# # Create user's dataframe given the inputted data
# user_wine_data <- eval(parse(text = df))
# 
# # Print the data.frame just to be 100% sure it's working
# print(user_wine_data)
# 
# # Predict this information given the user's dataframe
# pred <- predict(wine.step,newdata=user_wine_data,interval="prediction",level=0.95)
# 
# # Print the prediction data for check up!
# print(pred)
# 

########## DATA VALIDATION ########

library(class)

# Capture needed set
wine_sub <- wine_sub[,1:12]

# Creating the rating system
wine_sub$rating <- ifelse(wine_sub$quality < 5, 'poor', ifelse(wine_sub$quality < 7, 'average', 'excellent'))

wine_sub$rating <- as.factor(wine_sub$rating)

# Train using 75% of the full data
train = sample(6497,nrow(wine_sub) * 0.75)

# Create test and train
wine_sub.train <- wine_sub[train,]
wine_sub.test <- wine_sub[-train,]

# Predict the data set given the subset
wine.probs = predict(wine.step,wine_sub.test,type="response")

# Categorize accordingly
wine.pred = rep("poor",length(wine.probs))
wine.pred[glm.probs>5]="average"
wine.pred[glm.probs>7]="excellent"

# Table between Predition and Test
table(wine.pred, wine_sub.test$rating)

# Success Rate
mean(wine.pred == wine_sub.test$rating)