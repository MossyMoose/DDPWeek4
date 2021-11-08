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

gdpDeflator <- read.csv(file="https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1168&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=GDPDEF&scale=left&cosd=1947-01-01&coed=2021-07-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Quarterly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2021-11-07&revision_date=2021-11-07&nd=1947-01-01")
gdpDeflator$DATE <- as.Date(gdpDeflator$DATE, format="%Y-%m-%d")
gdpMin <- min(gdpDeflator$DATE)
gdpMax <- max(gdpDeflator$DATE)

# Define server logic
shinyServer(function(input, output) {
    
    # Create slider in UI with min and max of data
    output$dateSlider <- renderUI({
        sliderInput(inputId = "dateRange",
                    label = "",
                    value = c(gdpMin,gdpMax),
                    min = gdpMin,
                    max = gdpMax,
                    dragRange = TRUE)
    })
    
    output$plot <- renderPlot({
        # Subset data based on slider
        gdpSubset <- subset(gdpDeflator, DATE >= input$dateRange[1] &
                                DATE <= input$dateRange[2])
        gdpRows <- nrow(gdpSubset)
        minX <- gdpSubset[1,1]
        maxX <- gdpSubset[gdpRows,1]
        minY <- gdpSubset[1,2]
        maxY <- gdpSubset[gdpRows,2]
        
        # Plot subsetted data
        gdpPlot <- ggplot(gdpSubset, aes(x=DATE, y=GDPDEF)) +
            geom_point() +
            labs(x="Date", y="GDP Deflator")
        
        return(gdpPlot)
    })
    
    output$cagr <- renderText({
        # Calculate and return the compound annual growth rate
        gdpSubset <- subset(gdpDeflator, DATE >= input$dateRange[1] &
                                DATE <= input$dateRange[2])
        gdpRows <- nrow(gdpSubset)
        
        cagr <- ((gdpSubset[gdpRows,2]/gdpSubset[1,2])^
                     (1/(gdpSubset[gdpRows,2]-gdpSubset[1,2]))) - 1
        
        cagrText <- c("Based on your selection, we are calculating annualized ",
                      "inflation (using the compound annual growth rate) for ",
                      format(gdpSubset[1,1],"%m/%Y"), " to ",
                      format(gdpSubset[gdpRows,1],"%m/%Y"), " (", gdpRows,
                      " observations). During this period, the GDP Deflator ",
                      "grew from ", gdpSubset[1,2], " to ", gdpSubset[gdpRows,2],
                      ", resulting in annualized inflation of ",
                      round(cagr*100,3), "%.")
        return(cagrText)
    })
    

})
