library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    sliderInput(inputId = "num", label = "Choose a number", value = 25, min = 1, max = 100),
    plotOutput("hist")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$hist <- renderPlot({
        title <- "100 random normal values"
        hist(rnorm(input$num))})
    
}

# Run the application 
shinyApp(ui = ui, server = server)
