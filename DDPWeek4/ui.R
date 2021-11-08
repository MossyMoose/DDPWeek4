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
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Estimated Rate of Inflation from GDP Deflator"),

    # Slide bar with minimum and maximum date for GDP Deflator range
    sidebarLayout(
        sidebarPanel(
            "This simple Shiny app uses GDP Deflator data to calculate the ",
            "inflation rate, allowing you to select the date range over which ",
            "to calculate.",
            h4("Select a date range"),
            "Use the slider below to select your date range. Note that the ",
            "data are available every 3 months, so the application will just ",
            "find those quarterly data points that fit within the range you ",
            "specify.",
            # Slider to select date range to look at
            uiOutput('dateSlider')
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("GDP Deflator Over Time"),
            plotOutput("plot"),
            h3("Inflation Over This Period"),
            textOutput("cagr")
        )
    )
))
