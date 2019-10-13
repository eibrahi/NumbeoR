#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)


df_master <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/MasterDF.csv", header=TRUE)
df_master <- mutate(df_master, Year2=as.character(df_master$Year))
glimpse(df_master)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {


    output$numbPlot <- renderPlot({
        test <- filter(df_master, Year==input$Year2)
        ggplot(test) +
            geom_point(mapping = aes(x=Crime.Index, y=Health.Care.Index, color=Continent, s=Country))
        

    })
    
    output$numbPlot2 <- renderPlot({
        test <- filter(df_master, Year==input$Year2)
        ggplot(test) +
            geom_point(mapping = aes(x=Crime.Index, y=Health.Care.Index, color=Continent, s=Country))
        
        
    })

})
