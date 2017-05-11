library(shiny)
library(jsonlite)
library("stargazer", lib.loc="/home/cheese/R/x86_64-pc-linux-gnu-library/3.2")

##### TEAM CHEESE DASHBOARD #####

wine_data <- read.csv("/home/cheese/shiny-server/wine/data/winequality.csv")
rating <- c("Poor", "Average", "Excellent")

# dia.full <- lm(quality ~ pH + fixed.acidity * volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide * total.sulfur.dioxide * sulphates + density * alcohol, data = wine_data)
# dia.step3 <- step(dia.full, direction = "both")
# print(summary(dia.step3))

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  # Reactive expression to generate the requested distribution. This is 
  # called whenever the inputs change. The output renderers defined 
  # below then all used the value computed from this expression
  
  # Listen to events on the page
  observe({
    
    if(input$winetype != "all") {
      # Create subset of the wine selected by the user
      wine_sub <- subset(wine_data, wine == input$winetype)
    } else {
      wine_sub <- wine_data
    }
    
    
    # Identify the pie chart data (Quality Data)
    pie_data <- as.data.frame(table(wine_sub$quality))
    
    # Convert Quality levels to Numeric
    pie_data$Var1 <- as.numeric(as.character(pie_data$Var1))
    
    # Create empty vector that contains aggregate of rating
    score <- c()
    # Set the rating
    # Poor: 1 - 4
    # Average: 5 - 6
    # Excellent: 7 - 10
    score <- c(score, sum(pie_data[pie_data$Var1 < 5,2]))
    score <- c(score, sum(pie_data[pie_data$Var1 > 4 & pie_data$Var1 < 7,2]))
    score <- c(score, sum(pie_data[pie_data$Var1 > 6,2]))
    
    # Compile JSON Data
    jsonOutput <- toJSON(data.frame(rating, score))
     
    # Send data to JS
    session$sendCustomMessage(type = "piechart",jsonOutput)
    
    # Change the column names to readable format for the summary data
    colnames(wine_sub) <- c("Fixed Acidity","Volatile Acidity","Citric Acid","Residual Sugar","Chlorides","Free Sulfur Dioxide","Total Sulfur Dioxide","Density","pH","Sulphates","Alcohol","Quality","Wine")
    
    output$summary <- renderPrint({
      stargazer(wine_sub,type="html", digits = 2)
    })
  })
  
})