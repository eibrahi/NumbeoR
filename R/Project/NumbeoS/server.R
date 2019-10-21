#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(ggplot2)
library(dplyr)
library(fpp2)                          # forecasting/times series
library(fpp3)                          # forecasting/times series
library(tsibble)                       # tsibble object used for forecasting
library(plotly)                        # visualizations




df_master <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/MasterDF.csv", header=TRUE)
df_clean <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/CleanDF.csv", header=TRUE)

#Was passiert hier warum machen wir das?????
df_master <- mutate(df_master, Year2=as.character(df_master$Year))

df_Germany <- filter(df_clean, Country=="Germany")
tsibble_Germany <- as_tsibble(df_Germany, index=Year)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    output$Forecast <- renderPlot({
    
        fit_ets <- tsibble_Germany %>%
            model(ETS(Crime ~ error(input$error) + trend(input$trend) + season(input$season), opt_crit = input$Criterion))
        fc_ets <- fit_ets %>%
            forecast(h = 3)
        
        fc_ets %>%
            autoplot(tsibble_Germany) +
             geom_line(aes(y = .fitted, colour = "Fitted"), data = augment(fit_ets)) +
             ylab("Crime Index") + xlab("Year")
     })

    output$numbPlot <- renderPlotly({
        df_master <- filter(df_master, Year==input$YearBub)
        
        datax <- switch(input$xVar, 
                        "Pollution Index" = df_master$Pollution,
                        "Crime Index" = df_master$Crime,
                        "Health Care Index" = df_master$HealthCare,
                        "Cost of Living Index" = df_master$CostOfLiving,
                        "Rent Index" = df_master$Rent)
        datay <- switch(input$yVar, 
                        "Pollution Index" = df_master$Pollution,
                        "Crime Index" = df_master$Crime,
                        "Health Care Index" = df_master$HealthCare,
                        "Cost of Living Index" = df_master$CostOfLiving,
                        "Rent Index" = df_master$Rent)
        datab <- switch(input$bubble, 
                        "Pollution Index" = df_master$Pollution,
                        "Crime Index" = df_master$Crime,
                        "Health Care Index" = df_master$HealthCare,
                        "Cost of Living Index" = df_master$CostOfLiving,
                        "Rent Index" = df_master$Rent)
        
        ggplot(df_master) +
            geom_point(mapping = aes(x=datax, y=datay, size=datab, color=Continent, s=Country)) + 
                        xlab(input$xVar) + 
                        ylab(input$yVar) + 
                        ggtitle(paste0(input$xVar , " vs." , input$yVar))


    })

})
