# Cheese

## What's Cheese?
Cheese is an online analytical tool that helps wine managers and wine chemists to identify the potential quality of their wine based on the wine's chemical properties. Based on the information provided by the user, Cheese processes the inputted data with a model dynamically generated based on 6,500 instances of wine data.

## What's the Data?
Cheese uses the data collected from professor Cortez's research in Portugal. The data was collected from the Viticulture Commission of the Vinho Verde Region of Portugal. The data set is available publicly on [University of California, Irvine - Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Wine+Quality).

The complete citation is as follows:

```
Paulo Cortez, University of Minho, Guimarães, Portugal, http://www3.dsi.uminho.pt/pcortez

A. Cerdeira, F. Almeida, T. Matos and J. Reis, 
Viticulture Commission of the Vinho Verde Region(CVRVV), Porto, Portugal 
@2009

```

It's evident that potential biases may exist with this data given the quality data is primarily targeted for the Portuguese wine critics, and this may influence the outcome of our quality analysis.

## How did you find a model?
Cheese creates its model dynamically based on the user's selection and input.
The process involves the following steps:

1. Identify the type of wine selected by the user.
2. Run stepwise multiple regression model.
3. Identify lowest AIC model.
4. Build the linear model.
5. Utilize only the selected attributes for the model.

The following code provides an insight as to how the process is done in the R Server


```splus
# Create null model
wine.null <- lm(quality ~ 1, data = wine_sub)

# Run stepwise analysis
wine.step <- step(wine.null, scope = .~. + pH * fixed.acidity * volatile.acidity * citric.acid + residual.sugar + chlorides 
+ free.sulfur.dioxide * total.sulfur.dioxide * sulphates + density * alcohol)

# Explore the selected model
summary(wine.step)

# Collect the model information
model <- wine.step$call

# Dynamically process the attributes. This process involves:
# Loop through variables -> Examining which attributes we need
# Pasting the information -> concatenates all expressions to string
# Parse the information -> Parse the text into R code
# Evaluate the parsed information -> run that script with R

# Empty string to create the dataframe
df = ""

# Loop through the selected variables for the loop
for (i in 3:length(attr(wine.step$terms,"variables"))) {
  
  # Collect variable name
  var_name <- attr(wine.step$terms,"variables")[[i]]
  
  # Feed the data frame
  df <- paste(df,var_name,"=c(",var_name,".val)", sep = "")
  
  # Concatenate with commas
  if (i != length(attr(wine.step$terms,"variables"))) {
    df <- paste(df,",")
  }
  
}

# Wrap for data.frame
df <- paste("data.frame(",df,")", sep = "")

# Create user's dataframe given the inputted data
user_wine_data <- eval(parse(text = df))

# Predict this information given the user's dataframe
pred <- predict(wine.step,newdata=user_wine_data,interval="prediction",level=user_prediction_level)

```

## What's the output?
The output generated from the model is an estimate of the wine's quality based on the past results collected from the data set. The wine quality measure is subjective, and simply provides a benchmark of the potential quality of the wine if it were to be tested by the same group of critics that examined the original wines that were collected in the database.

## How accurate is the model?
Based on R's data validation techniques, we've estimated that the potential error is at 72.5% using a dynamic stepwise selection tool. The following code describes the data validation process:

```splus
# Capture needed set
wine_sub <- wine_sub[,1:12]

# Create the rating system
wine_sub$rating <- ifelse(wine_sub$quality < 5, 'poor', ifelse(wine_sub$quality < 7, 'average', 'excellent'))

# Assign the type for that column
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
```