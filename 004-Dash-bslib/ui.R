library(shiny)
library(plotly)
library(gridlayout)
library(bslib)
library(DT)
library(bsicons)

boxes <- layout_column_wrap(
  width = 1/3, fill = FALSE,
  value_box(
    "Total diamonds",
    scales::comma(nrow(diamonds)),
    showcase = bsicons::bs_icon("gem", size = NULL)
  ),
  value_box(
    "Average price", 
    scales::dollar(mean(diamonds$price), accuracy = 1),
    showcase = bsicons::bs_icon("coin", size = NULL),
    theme_color = "success"
  ),
  value_box(
    "Average carat",
    scales::number(mean(diamonds$carat), accuracy = .1),
    showcase = bsicons::bs_icon("search", size = NULL),
    theme_color = "dark"
  )
)

ui <- grid_page(
  layout = c(
    "value_box value_box value_box",
    "sidebar   bluePlot  bluePlot ",
    "table     table     plotly   ",
    "table     table     plotly   ",
    "table     table     .        "
  ),
  row_sizes = c(
    "1fr",
    "1.73fr",
    "0.27fr",
    "1.27fr",
    "0.73fr"
  ),
  col_sizes = c(
    "250px",
    "0.79fr",
    "1.21fr"
  ),
  gap_size = "1rem",
  grid_card(
    area = "sidebar",
    card_header("Settings"),
    card_body_fill(
      sliderInput(
        inputId = "bins",
        label = "Number of Bins",
        min = 12,
        max = 100,
        value = 30,
        width = "100%"
      ),
      numericInput(
        inputId = "numRows",
        label = "Number of table rows",
        value = 10,
        min = 1,
        step = 1,
        width = "100%"
      )
    )
  ),
  grid_card(
    area = "table",
    card_header("Table"),
    card_body_fill(
      DTOutput(outputId = "myTable", width = "100%")
    )
  ),
  grid_card_plot(area = "bluePlot"),
  grid_card(
    area = "plotly",
    card_header("Interactive Plot"),
    card_body_fill(
      plotlyOutput(
        outputId = "distPlot",
        width = "100%",
        height = "100%"
      )
    )
  ),
  grid_card(area = "value_box", card_body_fill(boxes))
)


