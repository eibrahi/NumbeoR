#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(navbarPage("NumbeoR",
                               
                               tabPanel("Forecast analysis",
                    
                                    # Application title
                                    titlePanel("Crime Index"),
                    
                                    # Sidebar with a slider input for number of bins
                                    sidebarLayout(
                                        sidebarPanel(
                                            selectInput("Criterion", 
                                                        "Chose the criterion", 
                                                        choices = c(
                                                          "Log Likelihood" = "lik", 
                                                          "Mean Square Error" = "mse", 
                                                          "Average MSE" = "amse", 
                                                          "Standard deviation of residuals" = "sigma", 
                                                          "Mean Absolute Error" = "mae"), 
                                                        selected = "mse"
                                            ),
                                            
                                            # Horizontal line ----
                                            tags$hr(),
                                            
                                            # Input: Select Error ----
                                            radioButtons("error", 
                                                         "Error",
                                                           choices = c(Additive = "A",
                                                                       None = "N",
                                                                       Multiplicative = "M"),
                                                           selected = "A"
                                            ),
                                            
                                            # Horizontal line ----
                                            tags$hr(),
                                            
                                            # Input: Select Trend ----
                                            radioButtons("trend", 
                                                         "Trend",
                                                         choices = c(Additive = "A",
                                                                     None = "N"
                                                                     #, Multiplicative = "M"
                                                                     ),
                                                         selected = "N"
                                            ),
                                            
                                            # Horizontal line ----
                                            tags$hr(),
                                            
                                            # Input: Select season ----
                                            radioButtons("season", 
                                                         "Season",
                                                         choices = c(Additive = "A",
                                                                     None = "N",
                                                                     Multiplicative = "M"),
                                                         selected = "N"
                                            )
                                        ),
                    
                                        # Show a plot of the generated distribution
                                        #mainPanel(plotlyOutput("Forecast")
                                        mainPanel(plotOutput("Forecast")
                                        )
                                    )
                                ),
                                
                               tabPanel("Plots",
                                         
                                    # Application title
                                    titlePanel("Investigation of interrelationships between indices"),
                                         
                                    # Sidebar with a slider input for number of bins
                                    sidebarLayout(
                                        sidebarPanel(
                                            sliderInput("YearBub",
                                                        "Chose the year:", 
                                                        min=2012, 
                                                        max=2019, 
                                                        value = 2012, 
                                                        step = 1, 
                                                        animate = animationOptions(
                                                          750, 
                                                          loop=FALSE, 
                                                          playButton = NULL, 
                                                          pauseButton = NULL
                                                          )
                                            ),
                          
                                            selectInput("xVar", 
                                                        "Chose the x Variable", 
                                                        c(
                                                          "Pollution Index",
                                                          "Crime Index", 
                                                          "Health Care Index", 
                                                          "Cost of Living Index",  
                                                          "Rent Index"
                                                          ), 
                                                        selected = "Pollution Index" 
                                            ), 
                                        
                                            selectInput("yVar", 
                                                        "Chose the y Variable", 
                                                        c(
                                                          "Pollution Index",  
                                                          "Crime Index", 
                                                          "Health Care Index", 
                                                          "Cost of Living Index", 
                                                          "Rent Index"
                                                          ),
                                                        selected = "Crime Index"
                                            ),
                                            
                                            selectInput("bubble", 
                                                        "Chose the size Variable", 
                                                        c(
                                                          "Pollution Index", 
                                                          "Crime Index", 
                                                          "Health Care Index", 
                                                          "Cost of Living Index", 
                                                          "Rent Index"
                                                          ), 
                                                        selected = "Cost of Living Index" 
                                            )  
                                        ),
                          
                                        # Show a plot of the generated distribution
                                        #mainPanel(plotOutput("numbPlot")
                                        mainPanel(plotlyOutput("numbPlot")
                                        )
                                    )
                                )
        
                               #,widths = c(2, 10)
                             )
    )
)

