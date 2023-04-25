library(ggplot2)
library(gt)
library(stringr)

server <- function(input, output) {
  
  cylinders <- reactive({
    input$bins
  })
  
  data <- reactive({
    subset (mtcars, cyl == cylinders())
  })
  
  observe({
    print(cylinders())
    
  })
  
    output$plot <- renderPlot({
      ggplot(data(), aes(x=.data[["mpg"]], y=data()$hp, color=data()$mpg)) +
        geom_point() 
    })
    
    output$table <- DT::renderDT({
      data()
    })

}

