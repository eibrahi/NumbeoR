#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#

# used libraries
library(shiny)      # web application framework
library(ggplot2)    # create elegant data visualisations
library(dplyr)      # flexible grammar of data manipulation
library(fpp2)       # forecasting/times series
library(fpp3)       # forecasting/times series
library(tsibble)    # tsibble object used for forecasting
library(plotly)     # visualizations

# import dataframes as csv files from GitHub
df_master <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/MasterDF.csv", 
                      header=TRUE)
df_clean <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/CleanDF.csv", 
                     header=TRUE)

# filter german data for forcasting 
df_Germany <- filter(df_clean, Country=="Germany")

# transform data into a specific format "tsibble" preparing for using in the forcast function
tsibble_Germany <- as_tsibble(df_Germany, index=Year)

# Define server logic required to draw a scatter plot and a forcast
shinyServer(function(input, output) {
   
    # transfer of the scatterplot to the UI via reactivity
    output$numbPlot <- renderPlotly({
      
      # filter data frame according to required data 
      df_master <- filter(df_master, Year==input$YearBub)
        
      # use switch statement to translate the Input
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
        
      # create the scatter plot
      ggplot(df_master) +
            geom_point(mapping = aes(x=datax, y=datay, size=datab, color=Continent, s=Country)) + 
                        xlab(input$xVar) + 
                        ylab(input$yVar) + 
                        ggtitle(paste0(input$xVar , " vs. " , input$yVar))
    })
    
    # transfer of the forcaste to the UI via reactivity
    output$Forecast <- renderPlot({
        
      # build the model for the plot functio 
      fit_ets <- tsibble_Germany %>%
            model(ETS(Crime ~ error(input$error) + 
            trend(input$trend) + season(input$season), 
            opt_crit = input$Criterion))
      
      # define how many years to forecast
      fc_ets <- fit_ets %>%
            forecast(h = 3)
      
      # create the forcast plot 
      fc_ets %>%
            autoplot(tsibble_Germany) +
            geom_line(aes(y = .fitted, colour = "Fitted"), data = augment(fit_ets)) +
            ylab("Crime Index") + xlab("Year")
    })
    
})
