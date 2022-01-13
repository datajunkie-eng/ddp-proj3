library(shiny)
library(plotly)
library(lubridate)

shinyServer(function(input, output) {

    data <- read.csv("Net_generation_United_States_all_sectors_monthly.csv", quote="", skip=4)
    
    names(data) <- c("month", "all", "coal", "natural.gas", "nuclear", "hydro", "wind", "solar")

    ffDisplay <- reactive({input$ffDisplay})
    renDisplay <- reactive({input$renDisplay})
    scale <- reactive({input$scale})
    
    data$month <- my(data$month)
    
    output$plot1 <- renderPlotly({
        
        scaler <- function(x) {
            if( scale() == "Standard") {
                x
            }
            else {
                log10(x)
            }
        }

        fig <- plot_ly(data, x=~month, y =~scaler(all), name = 'All', mode = 'lines',type="scatter", height=600)
        
        if( ffDisplay() == "Show Individually") {
            fig <- fig %>% add_trace(data, y =~scaler(coal), name = 'Coal', mode = 'lines')
            fig <- fig %>% add_trace(data, y =~scaler(natural.gas), name = 'Natural Gas', mode = 'lines')
        }
        if( ffDisplay() == "Show Combined") {
            fig <- fig %>% add_trace(data, y =~scaler(coal + natural.gas), name = 'Fossil Fuels', mode = 'lines')
        }
        
        if( renDisplay() == "Show Individually") {
            fig <- fig %>% add_trace(data, y =~scaler(hydro), name = 'Hydroelectric', mode = 'lines')
            fig <- fig %>% add_trace(data, y =~scaler(wind), name = 'Wind', mode = 'lines')
            fig <- fig %>% add_trace(data, y =~scaler(solar), name = 'Solar', mode = 'lines') 
        }
        if( renDisplay() == "Show Combined") {
            fig <- fig %>% add_trace(data, y =~scaler(hydro+wind+solar), name = 'Renewables', mode = 'lines')
        }
        
            fig <- fig %>% layout(xaxis = list(title = 'Year'), 
                              yaxis = list(title = ifelse(scale() == "Standard", 'Thousand MegaWatt Hours', 'Thousand MegaWatt Hours (log 10)')))
        fig
    })

})
