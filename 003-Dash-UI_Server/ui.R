library(shiny)
library(ggplot2)
library(gridlayout)
library(bslib)
library(plotly)

############ 
# TABS
############

data_tab <- tabPanel(
  title = icon("table"),
  value = "data",
  column(
    width = 12, 
    uiOutput("data_title"),
    DT::DTOutput("table"),
    plotOutput("plot")
  )
)

####

ui <- fluidPage(
  
  navbarPage(
    "My navigation bar",
    tabPanel("Input",
             sliderInput(inputId = "bins", label = "Select the range of bill length?", value = c(4), min = 0, max = 8),
    ),
    navbarMenu("Analysis",
               tabPanel("Plot",
                        plotOutput("plot")
               ),
               tabPanel("Table",
                        DT::DTOutput("table")
               )
    )
)
)
      
    
  


