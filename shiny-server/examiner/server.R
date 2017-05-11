library(shiny)
library(jsonlite)

##### TEAM CHEESE EXAMINER #####

# Pull the data set
wine_data <- read.csv("/home/cheese/shiny-server/wine/data/winequality.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  # Listen to events on the page
  observe({
    
    print(input$js_trigger)
    
    # Collect the Wine Subset
    wine_sub <- subset(wine_data, wine == input$winetype)
    
    # Create null variable
    wine.null <- lm(quality ~ 1, data = wine_sub)
    
    # Identify the best model using step
    wine.step <- step(wine.null, scope = .~. + pH + fixed.acidity * volatile.acidity * citric.acid + residual.sugar + chlorides + free.sulfur.dioxide * total.sulfur.dioxide * sulphates + density * alcohol)
    
    # Print in the machine
    print(summary(wine.step))
    
    # Retrieve the model generated from the step function. Just because (not really useful)
    model <- wine.step$call
    
    # Since we're pulling data from the UI which are in the form of string (or character)
    # we need to convert everything into double (not int, otherwise we lose decimals)
    
    # First, set the number of significant figures we're dealing with.
    # Based on the sliders, 4 is a good number.
    options(digits = 4)
    
    # Collect the dataset, son!
    # ...and convert everything to double
    fixed.acidity.val = isolate(as.double(input$fixed_acidity))
    volatile.acidity.val = isolate(as.double(input$volatile_acidity))
    citric.acid.val = isolate(as.double(input$citric_acid))
    residual.sugar.val = isolate(as.double(input$residual_sugar))
    chlorides.val = isolate(as.double(input$chlorides))
    free.sulfur.dioxide.val = isolate(as.double(input$free_sulfur_dioxide))
    total.sulfur.dioxide.val = isolate(as.double(input$total_sulfur_dioxide))
    density.val = isolate(as.double(input$density))
    pH.val = isolate(as.double(input$pH))
    sulphates.val = isolate(as.double(input$sulphates))
    alcohol.val = isolate(as.double(input$alcohol))
    
    # Evaluate this ridiculously complicated expression based on the provided terms
    
    # The process involves:
    # Pasting the information -> concatenates all expressions to string
    # Parse the information -> Parse the text into R code
    # Evaluate the parsed information -> run that thing, baby!
    
    # Empty string to create the dataframe
    df = ""
    
    # Loop through the selected variables for the loop
    # Starts from the third element because we want to exclude
    # List and Quality from the options
    for (i in 3:length(attr(wine.step$terms,"variables"))) {
      
      # Collect variable name
      var_name <- attr(wine.step$terms,"variables")[[i]]
      
      # Feed the data frame
      df <- paste(df,var_name,"=c(",var_name,".val)", sep = "")
      
      # Need commas ya'know
      if (i != length(attr(wine.step$terms,"variables"))) {
        df <- paste(df,",")
      }
      
    }
    
    # Wrap for data.frame
    df <- paste("data.frame(",df,")", sep = "")
    
    # Create user's dataframe given the inputted data
    user_wine_data <- eval(parse(text = df))
    
    # Print the data.frame just to be 100% sure it's working
    print(user_wine_data)
    
    # Predict this information given the user's dataframe
    # Collect prediction interval from user
    pred <- predict(wine.step,newdata=user_wine_data,interval="prediction",level=as.double(input$pred_inter))
    
    # Send JSON data with the quality outcome (send prediction data)
    session$sendCustomMessage(type = "quality_examiner",toJSON(pred[1,]))
    
  })
  
  # Kill Shiny Session when browser is closed
  session$onSessionEnded(stopApp)
})