library("randomForest", lib.loc="/home/cheese/R/x86_64-pc-linux-gnu-library/3.2")

wine <- read.csv("/home/cheese/shiny-server/wine/data/winequality.csv")
wine$taste <- ifelse(wine$quality < 6, 'bad', 'good')
wine$taste[wine$quality == 6] <- 'normal'
wine$taste <- as.factor(wine$taste)

set.seed(1)
train <- sample(nrow(wine), 0.6 * nrow(wine))
wine.train <- wine[train, ]
wine.test <- wine[-train, ]

model <- randomForest(taste ~ . - quality, data = wine.train, mtry = 12)
print(model)
pred <- predict(model, newdata = wine.test)
table(pred, wine.test$taste)

