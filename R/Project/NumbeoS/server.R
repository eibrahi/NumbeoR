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
library(fpp2)                          # forecasting/times series
library(fpp3)                          # forecasting/times series
library(tsibble)                       # tsibble object used for forecasting

library(plotly)                        # visualizations


df_master <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/MasterDF.csv", header=TRUE)
df_clean <- read.csv(file="https://raw.githubusercontent.com/eibrahi/NumbeoR/master/daten/CleanDF.csv", header=TRUE)
df_master <- mutate(df_master, Year2=as.character(df_master$Year))
glimpse(df_master)


df_Germany <- filter(df_clean, Country=="Germany")
tsibble_Germany <- as_tsibble(df_Germany, index=Year)

fit_ets <- tsibble_Germany %>%
    model(ETS(Crime.Index ~ error("A") + trend("N") + season("N"), opt_crit = "mse"))
fc_ets <- fit_ets %>%
    forecast(h = 3)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {


    output$Forecast <- renderPlot({
        fc_ets %>%
             autoplot(tsibble_Germany) +
             geom_line(aes(y = .fitted, colour = "Fitted"), data = augment(fit_ets)) +
             ylab("Crime Index") + xlab("Year")
     })

    output$numbPlot <- renderPlot({
        crimeVsHealth <- filter(df_master, Year==input$YearBub)
        ggplot(crimeVsHealth) +
            geom_point(mapping = aes(x=Crime.Index, y=Health.Care.Index, color=Continent, s=Country))


    })

})
