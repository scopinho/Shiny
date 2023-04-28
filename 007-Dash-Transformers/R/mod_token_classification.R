

token_classification_UI <- function(id) {
  ns <- NS(id)
  tagList(
    
    
    
    layout_column_wrap(
      width = 1/2, height = 300,
      card(
        textAreaInput(inputId = ns("text"), label = "Text", value = "Initial Text...")
      ),
      card(
        textOutput(outputId = ns("result"))
      )
    )
    
  )
}

token_classification_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      output$result <- renderText(input$text)
      
    }
  )
}