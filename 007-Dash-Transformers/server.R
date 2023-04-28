

get_predict <- function(text){
  outputs <- classifier(text)
  outputs |>
    purrr::pluck(1) |> 
    tibble::as_tibble()
}

server <- function(input, output, session) {
  
  text2 <- eventReactive(input$myButton,{
    input$myTextInput
    }
  )
  
   observeEvent(input$myButton, {
     # outputs <- predict(text2())
  #     #browser()
      output$textOutput <- renderTable (get_predict(text2()))
  #     output$textOutput <- renderText(text2())
  #     # updateTextAreaInput(session, "myTextInput", value = "New text")
   })
  
  #outputs <- classifier(text)
  #outputs %>% 
  #  pluck(1) %>% 
  #  as_tibble()
   
  token_classification_Server("tab2")
  
}

