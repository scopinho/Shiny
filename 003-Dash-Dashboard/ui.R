library(shiny)
library(ggplot2)
library(gridlayout)
library(bslib)
library(plotly)


ui <- navbarPage(
  title = "Chick Weights",
  selected = "Line Plots",
  collapsible = TRUE,
  theme = bslib::bs_theme(),
  tabPanel(
    title = "Line Plots",
    grid_container(
      layout = c(
        "num_chicks linePlots"
      ),
      row_sizes = c(
        "1fr"
      ),
      col_sizes = c(
        "250px",
        "1fr"
      ),
      gap_size = "10px",
      grid_card(
        area = "num_chicks",
        card_header("Settings"),
        card_body_fill(
          sliderInput(
            inputId = "numChicks",
            label = "Number of chicks",
            min = 1,
            max = 15,
            value = 5,
            step = 1,
            width = "100%"
          ),
          checkboxInput(
            inputId = "myCheckboxInput",
            label = "Checkbox Input",
            value = FALSE
          ),
          plotlyOutput(outputId = "plot")
        )
      ),
      grid_card_plot(area = "linePlots")
    )
  ),
  tabPanel(
    title = "Distributions",
    grid_container(
      layout = c(
        "facetOption",
        "dists"
      ),
      row_sizes = c(
        "165px",
        "1fr"
      ),
      col_sizes = c(
        "1fr"
      ),
      gap_size = "10px",
      grid_card_plot(area = "dists"),
      grid_card(
        area = "facetOption",
        card_header("Distribution Plot Options"),
        card_body_fill(
          radioButtons(
            inputId = "distFacet",
            label = "Facet distribution by",
            choices = list("Diet Option" = "Diet", "Measure Time" = "Time")
          )
        )
      )
    )
  )
)

