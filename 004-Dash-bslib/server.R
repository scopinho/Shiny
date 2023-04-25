library(plotly)


server <- function(input, output) {
   
  output$distPlot <- renderPlotly({
    # generate bins based on input$bins from ui.R
    p <- plot_ly(x = ~ faithful[, 2], type = "histogram")
    p <- p |> plotly::config(displaylogo = FALSE)
    p
  })
  
  output$bluePlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = "steelblue", border = "white")
  })
  
  output$myTable <- renderDT({
    head(faithful, input$numRows)
  })
  
  output$textOutput <- renderText({
    c("10000.00")
  })
}

