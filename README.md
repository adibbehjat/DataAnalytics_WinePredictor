# Wine Quality Predictor Tool

## Team Members
* Adib Behjat
* Marina Cholakyan
* Michael Lane

## A Winemaker’s Friend
Our application will be a chemistry-based app that will produce meaningful suggestions to vintners on how to make their wines better.  By feeding in input values measured by the vintner, they will receive suggestions on what changes to make to the wine to impact the quality.

## Evaluating Product Success
Winemaking goes through many stages starting from harvesting and destemming, primary (alcoholic) fermentation, pressing, cold stabilization, secondary (malolactic) fermentation, bulk aging, etc, all the way to actual bottling. Throughout the winemaking process laboratory tests are periodically run to check on the status of the wine. The test results are used by winemaker to decide on appropriate action, for example the addition of more sulfur dioxide or readiness to bottle the wine based on certain quality indicators. Wine quality incorporates many different layers. Wine quality can be analyzed using sensory as well as chemical methods. As a supplemental guide to the winemaker our product will offer wine quality prediction based on certain predictors that represent chemical components of the wine. Our product will help winemaker to predict the wine quality before bottling based on primary predictors such as chloride count, citric acidity, density and alcohol. Our initial set of training data contains eleven predictors - fixed acidity, volatile acidity, citric acid, residual sugar, chlorides, free sulfur dioxide, total sulfur dioxide, density, pH, sulfates and alcohol. Our product users are the people who create wine and interested in the quality of the wine.

To evaluate if the wine quality prediction is successful we can compare the predicted quality points to the new quality points that will be given by wine rating experts. The predicted quality points will have the same scale as the points given out by wine rating experts before bottling the wine.  To evaluate the fit of our model we need to look Residual Standard Error(RSE) which is  the average amount that the response will deviate from the true regression line and R square statistic which provides an alternative measure of fit. Below is an example of chloride predictor stats on quality. Since RSE is a small value we can conclude that our prediction model fits the data well.

### Chlorides

```R
> summary(cor)

Call:
lm(formula = chlorides ~ quality, data = winequality_red)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.06522 -0.01724 -0.00871  0.00327  0.51876 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.129808   0.008234  15.765  < 2e-16 ***
quality     -0.007513   0.001446  -5.195 2.31e-07 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.04669 on 1597 degrees of freedom
Multiple R-squared:  0.01662,	Adjusted R-squared:  0.016 
F-statistic: 26.99 on 1 and 1597 DF,  p-value: 2.313e-07
```


Our product users will record  top three or four predictor values of the wine to be bottled along with the rating points given by the wine experts.The predictor values along with wine expert quality points will be added to our training set. The new data will be used to refine our model to predict the wine quality more accurately.

## Choosing a Model

Due to the nature of the quality of wine being the ultimate goal of most vintners, the process of finding a model is easy.  Since the input variables are all correlated to quality, we can easily suggest making modifications to the variables that quality is most highly dependent upon (or that have the highest correlation value.)  As such, there is no need to adjust for interactive variables.

We have selected the following predictor variables based on their strong correlation to the quality outcome: volatile acidity, citric acid, sulfates, and alcohol.

For most of our models, a polynomial model was more accurate than linear.  However, the benefits of quartic over cubic over quadratic models were not immense, as displayed in the following graphs for each predictor:

## Testing the Model

We have also tested the quadratic model and found it to be effective using the following method:


```R
quality1 = wine.remaining$quality
quality2 = wine.remaining$quality^2
quadratic.model = lm(data=wine.remaining, volatile.acidity ~ quality1 + quality2)

intercept = coef(quadratic.model)[1]
slope1 = coef(quadratic.model)[2]
slope2 = coef(quadratic.model)[3]
outcomes = wine.sample$quality * slope1 + (wine.sample$quality * slope2)^2 + intercept
```

This produced some confidence-building results: for the most part, the values were right in line with the sample data.  Using the root mean squared log algorithm, we compared the accuracy of the results, with highly accurate outcomes of 0.07, 0.05, and 0.19.

```R
> wine.sample$volatile.acidity
 [1] 0.610 0.450 0.800 0.655 0.520 0.640 0.590 0.600 0.670 0.410
> outcomes
 [1] 0.5842190 0.5842190 0.4963871 0.5842190 0.6720510 0.5842190 0.4085551
 [8] 0.4963871 0.4963871 0.4963871
> rmsle(wine.sample$volatile.acidity, outcomes)
[1] 0.07136954

> wine.sample$alcohol
 [1] 11.1  9.3  9.5  9.5 11.3 11.0 10.8 10.0 12.0 11.4
> outcomes
 [1] 10.67008 10.03898 10.03898 10.03898 10.67008 11.30118 11.30118 10.03898
 [9] 11.30118 10.67008
> rmsle(wine.sample$alcohol, outcomes)
[1] 0.04793294

> wine.sample$citric.acid
 [1] 0.24 0.68 0.06 0.33 0.00 0.46 0.06 0.07 0.73 0.46
> outcomes
 [1] 0.2927320 0.2385859 0.2385859 0.2385859 0.2927320 0.3468782 0.3468782
 [8] 0.2385859 0.3468782 0.2927320
> rmsle(wine.sample$citric.acid, outcomes)
[1] 0.1877879

> wine.sample$sulphates
 [1] 0.63 0.75 0.48 0.61 0.67 0.64 0.66 0.50 0.59 0.77
> outcomes
 [1] 0.6267636 0.6267636 0.6783402 0.6267636 0.6783402 0.6783402 0.6783402
 [8] 0.6267636 0.6267636 0.7299167
> rmsle(wine.sample$sulphates, outcomes)
[1] 0.0543769
```

With these results, we can be confident that our model is accurate and that we are able to predict the outcome based on the variables chosen.