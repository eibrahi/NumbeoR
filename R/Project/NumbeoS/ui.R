#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        navlistPanel("NumbeoR",
            tabPanel("Plots",
    
                # Application title
                titlePanel("Crime Index vs. Health Care Index"),
            
                # Sidebar with a slider input for number of bins
                sidebarLayout(
                    sidebarPanel(
                        selectInput("Year","Chose the year:",c("2012", "2013","2014","2015","2016","2017","2018","2019")
                        ),
                    
                        sliderInput("Year2","Chose the year:",
                                min=2012, max=2019, value = 2012, step = 1, 
                                animate=animationOptions(750, loop=FALSE, playButton = NULL, pauseButton = NULL)
                        )
                
                    ),
                
                # Show a plot of the generated distribution
                    mainPanel(
                        plotOutput("numbPlot")
                    )
                )
            ),
            
            tabPanel("Placeholder",
                     # Application title
                     titlePanel("Crime Index vs. Health Care Index"),
                     
                     # Sidebar with a slider input for number of bins
                     sidebarLayout(
                         sidebarPanel(
                             selectInput("Year","Chose the year:",c("2012", "2013","2014","2015","2016","2017","2018","2019")
                             ),
                             
                             sliderInput("Year2","Chose the year:",
                                         min=2012, max=2019, value = 2012, step = 1, 
                                         animate=animationOptions(750, loop=FALSE, playButton = NULL, pauseButton = NULL)
                             )
                             
                         ),
                         
                         # Show a plot of the generated distribution
                         mainPanel(
                             plotOutput("numbPlot2")
                         )
                     )
            )
            
        )
    )
)
