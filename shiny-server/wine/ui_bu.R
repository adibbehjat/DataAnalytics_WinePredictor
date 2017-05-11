library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
    # Application title
    titlePanel("Testing RShiny for Cheese!"),
    
    # Sidebar Layout
    sidebarLayout(
      
      sidebarPanel(
        selectInput("winetype", "Wine Type", c("Red wine" = "red","White wine" = "white"))
      ), # End of sidebarPanel
    
      mainPanel(
        htmlOutput("json")
      ) # End of mainPanel
      
    ) # End of sidebarLayout
    
)) # End of Shiny UI