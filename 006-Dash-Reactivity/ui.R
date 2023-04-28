library(shiny)
library(plotly)
library(gridlayout)
library(bslib)
library(DT)

ui <- grid_page(
  layout = c(
    "b a",
    "b c"
  ),
  row_sizes = c(
    "0.41fr",
    "2.68fr"
  ),
  col_sizes = c(
    "165px",
    "1.43fr"
  ),
  gap_size = "1rem",
  grid_card(
    area = "b",
    card_header("Settings"),
    card_body(
      numericInput(
        inputId = "a",
        label = "a",
        value = 6
      ),
      numericInput(
        inputId = "b",
        label = "b",
        value = 1
      ),
      numericInput(
        inputId = "c",
        label = "c",
        value = 1
      )
    )
  ),
  grid_card(
    area = "c",
    card_body_fill(
      plotOutput(outputId = "x"),
      tableOutput(outputId = "y"),
      textOutput(outputId = "z"),
      textInput("rr", label = "RR", value = "0")
    )
  ),
  grid_card(area = "a")
)

