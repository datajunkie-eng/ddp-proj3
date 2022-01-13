library(shiny)
library(plotly)


shinyUI(fluidPage(
    titlePanel("Net US Energy Generation By Source"),
    sidebarLayout(
        sidebarPanel(
            selectInput("renDisplay", "Renewables", c("Show Individually", "Show Combined", "Suppress"), selected="Show"),
            selectInput("ffDisplay", "Fossil Fuels", c("Show Individually", "Show Combined", "Suppress"), selected="Show"),
            selectInput("scale", "Scale", c("Standard", "Log 10"), selected="Standard"),
            includeHTML("usage.html"),
            width=3
        ),
        mainPanel(
            plotlyOutput("plot1")
        )
    )
))




