

# UI ----------------------------------------------------------------------
ui <- navbarPage(
  title = "AI Demo",
  selected = "Text Classification",
  collapsible = TRUE,
  theme = bslib::bs_theme(),

## TAB-1 -------------------------------------------------------------------
  tabPanel(
    title = "Text Classification",
    grid_container(
      layout = c(
        "num_chicks area1"
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
        card_header("Review"),
        card_body_fill(
          textAreaInput(
            inputId = "myTextInput",
            label = "Text Input",
            height = "15rem",
            value = "Dear Amazon, last week I ordered an Optimus Prime action figure from your online store in Germany. Unfortunately, when I opened the package, I discovered to my horror that I had been sent an action figure of Megatron instead! As a lifelong enemy of the Decepticons, I hope you can understand my dilemma. To resolve the issue, I demand an exchange of Megatron for the Optimus Prime figure I ordered. Enclosed are copies of my records concerning this purchase. I expect to hear from you soon. Sincerely, Bumblebee."
          ),
          actionButton(inputId = "myButton", label = "Submit")
        )
      ),
      grid_card(
        area = "area1",
        full_screen = TRUE,
        card_header("Classification"),
        card_body_fill(tableOutput(outputId = "textOutput"))
      )
    )
    )
  ,

## TAB-2 -------------------------------------------------------------------
  tabPanel(
    title = "Token Classification",
    token_classification_UI("tab2")
  )
)

