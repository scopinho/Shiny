library(plotly)

### Resuminho

# reactive e eventReactive criam expressões associadas aos inputs
# observe e observeEvent reagem às expressoes criadas
# reactiveVal e reactiveVals criam valores reativos além dos "input" padrões
# isolate permite "pegar" o valor do valor reativo sem disparar sua reatividade

server <- function(input, output, session){
  df2 <- reactive (mtcars |> 
                     #select(.data[["cyl"]]) |> 
                     filter (.data[["cyl"]] > input$a ))
  
  rng <- reactive(input$a * 2)
  smp <- reactive(sample(rng(), input$b, replace = TRUE))
  bc <- reactive (input$b * input$c)
  
  #output$x <- renderPlot(hist(smp()))
  
  observeEvent(input$a,{
    #browser()
    updateTextInput(session = session, "rr", value = smp())
    #browser()
    output$x <- renderPlot(ggplot(df2(), aes(x=.data[["cyl"]], y=.data[["hp"]])) + geom_point())
    output$y <- renderTable(df2())
  })
  
  #output$y <- renderTable(max(smp()))
  output$z <- renderText(bc())
                   
}

