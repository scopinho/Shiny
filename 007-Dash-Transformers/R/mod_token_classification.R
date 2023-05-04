
token_classification_UI <- function(id, data) {
  
 ns <- NS(id)
  tagList(
    
    layout_column_wrap(
      width = 1/2, height = 500,
      card(
        card_body_fill(
        textAreaInput(inputId = ns("text"), label = "Text", value = "Initial Text..."),
        ),
        card_body_fill(
          selectizeInput(inputId = ns("locations"), label = "Locations", selected = NULL, choices = get_locations(dataset)),
          selectInput(inputId = ns("do_location"), label = "DO Location", choices = NULL),
          actionButton(inputId = ns("go"), label = "Go")
        )
      ),
    
  
      card(
        withSpinner(textOutput(outputId = ns("result"))),
        textOutput(outputId = ns("result2"))
        
      )
    )
    
  )
}

token_classification_Server <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      
      # ds <- data
      # 
      # locations <- data |> distinct(dispatching_base_num) |> dplyr::collect() |> dplyr::pull()
      # 
      location <- reactive({
        req(input$locations)
        input$locations
        })
      # 
      # location_2 <- reactive({
      #   print(input$text)
      # }) |>
      #   bindEvent(input$go)
      # 
      # output$result2 <- renderText({
      #   location_2()
      # })
      # 
      observe({

        location()

        values <- get_do_locations(dataset, location())
          
          # data |> 
          # select (dispatching_base_num, DOLocationID) |>
          # filter(dispatching_base_num == location()) |>
          # distinct(DOLocationID) |>
          # #distinct(lubridate::date(pickup_datetime)) |>
          # collect() |>
          # pull()
        
        

        updateSelectInput(session, inputId = "do_location", choices = values)

        
        #updateTextAreaInput(session, inputId = "text", value = values)

      })
      
      # x <- reactiveVal()
      # 
      # observe({
      #   
      #   x <- get_values(dataset, input$locations)
      #              })
      
      
      output$result <- renderText({
        req(input$do_location)
        input$do_location
      })
      
      
    }
  )
}

