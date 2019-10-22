#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#

# Used libraries
library(shiny)      # web application framework
library(ggplot2)    # create elegant data visualizations
library(dplyr)      # flexible grammar of data manipulation
library(fpp2)       # forecasting/times series
library(fpp3)       # forecasting/times series
library(tsibble)    # tsibble object used for forecasting
library(plotly)     # visualizations

# Import dataframes as csv files from GitHub
df_master <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/MasterDF.csv", 
                      header=TRUE)
df_clean <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/CleanDF.csv", 
                     header=TRUE)

# Filter german data for forcasting 
df_Germany <- filter(df_clean, Country=="Germany")

# Transform data into a specific format "tsibble" preparing for using in the forecast function
tsibble_Germany <- as_tsibble(df_Germany, index=Year)

# Define server logic required to draw a scatter plot and a forecast
shinyServer(function(input, output) {
   
    # Transfer of the scatterplot to the UI via reactivity
    output$numbPlot <- renderPlotly({
      
      # Filter data frame according to required data 
      df_master <- filter(df_master, Year==input$YearBub)
        
      # Use switch statement to translate the input
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
        
      # Create the scatter plot
      ggplot(df_master) +
            geom_point(mapping = aes(x=datax, y=datay, size=datab, color=Continent, s=Country)) + 
                        xlab(input$xVar) + 
                        ylab(input$yVar) + 
                        ggtitle(paste0(input$xVar , " vs. " , input$yVar))
    })
    
    # Transfer of the forecaste to the UI via reactivity
    output$Forecast <- renderPlot({
        
      # Build the model for the plot function 
      fit_ets <- tsibble_Germany %>%
            model(ETS(Crime ~ error(input$error) + 
            trend(input$trend) + season(input$season), 
            opt_crit = input$Criterion))
      
      # Define how many years to forecast
      fc_ets <- fit_ets %>%
            forecast(h = 3)
      
      # Create the forecast plot 
      fc_ets %>%
            autoplot(tsibble_Germany) +
            geom_line(aes(y = .fitted, colour = "Fitted"), data = augment(fit_ets)) +
            ylab("Crime Index") + xlab("Year")
    })
    
})
