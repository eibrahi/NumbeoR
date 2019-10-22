#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#

# used libraries
library(plotly)     # visualizations

# UI for application that draws a scatter plot and a forcast 
# uses a navbarPage function to create a menu
shinyUI(fluidPage(navbarPage("NumbeoR",
                               
                               
                             # first menu "Scatter plot"
                             tabPanel("Scatter plot",
                                      
                                      # Main title of the first page
                                      titlePanel("Investigation of interdependencies between indices"),
                                      
                                      # Creates a layout with a sidebar and main area.
                                      sidebarLayout(
                                        # Creates a sidebar panel containing input controls that can in turn be passed to sidebarLayout.
                                        sidebarPanel(
                                          
                                          # Input: Select the year including an animation function 
                                          sliderInput("YearBub",
                                                      "year:", 
                                                      min=2012, 
                                                      max=2019, 
                                                      value = 2012, 
                                                      step = 1, 
                                                      # animation function
                                                      animate = animationOptions(
                                                        750, 
                                                        loop=FALSE, 
                                                        playButton = NULL, 
                                                        pauseButton = NULL
                                                      )
                                          ),
                                          
                                          # Input: Select the x-axis
                                          selectInput("xVar", 
                                                      "x-axis", 
                                                      c(
                                                        "Pollution Index",
                                                        "Crime Index", 
                                                        "Health Care Index", 
                                                        "Cost of Living Index",  
                                                        "Rent Index"
                                                      ), 
                                                      selected = "Pollution Index" 
                                          ), 
                                          
                                          # Input: Select the y-axis
                                          selectInput("yVar", 
                                                      "y-axis", 
                                                      c(
                                                        "Pollution Index",  
                                                        "Crime Index", 
                                                        "Health Care Index", 
                                                        "Cost of Living Index", 
                                                        "Rent Index"
                                                      ),
                                                      selected = "Crime Index"
                                          ),
                                          
                                          # Input: Select the bubble size
                                          selectInput("bubble", 
                                                      "bubble size", 
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
                                        
                                        # Output: show a scatter plot
                                        mainPanel(plotlyOutput("numbPlot")
                                        )
                                      )
                             ),
                             
                             # second menu "Forecast"
                             tabPanel("Forecast",
                    
                                    # Main title of the second page
                                    titlePanel("Crime Index"),
                    
                                    # Creates a layout with a sidebar and main area.
                                    sidebarLayout(
                                     
                                      # Creates a sidebar panel containing input controls that can in turn be passed to sidebarLayout.  
                                      sidebarPanel(
                                         
                                        # Input: Select optimization criterion   
                                        selectInput("Criterion", 
                                                        "optimization criterion", 
                                                        choices = c(
                                                          "Log Likelihood" = "lik", 
                                                          "Mean Square Error" = "mse", 
                                                          "Average MSE" = "amse", 
                                                          "Standard deviation of residuals" = "sigma", 
                                                          "Mean Absolute Error" = "mae"), 
                                                        selected = "mse"
                                          ),
                                            
                                            
                                        # Horizontal line
                                        tags$hr(),
                                            
                                        # Input: Select Error   
                                        radioButtons("error", 
                                                         "error",
                                                           choices = c(Additive = "A",
                                                                       None = "N",
                                                                       Multiplicative = "M"),
                                                           selected = "A"
                                            ),
                                           
                                        # Horizontal line    
                                        tags$hr(),
                                            
                                        # Input: Select Trend
                                        radioButtons("trend", 
                                                         "trend",
                                                         choices = c(Additive = "A",
                                                                     None = "N"
                                                                     #, Multiplicative = "M"
                                                                     ),
                                                         selected = "N"
                                            ),
                                            
                                        # Horizontal line ----
                                        tags$hr(),
                                            
                                        # Input: Select Season ----
                                        radioButtons("season", 
                                                         "season",
                                                         choices = c(Additive = "A",
                                                                     None = "N",
                                                                     Multiplicative = "M"),
                                                         selected = "N"
                                            )
                                        ),
                    
                                      # Output: show a plot of the forecast
                                      mainPanel(plotOutput("Forecast")
                                      )
                                  )
                              )
                    )
    )
)

