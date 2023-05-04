library(shiny)
library(ggplot2)
library(gridlayout)
library(bslib, warn.conflicts = FALSE)
library(ggplot2)
library (DT, warn.conflicts = FALSE)
library (arrow)
library (dplyr, warn.conflicts = FALSE)
library (arrow, warn.conflicts = FALSE)
library (shinycssloaders)

get_db <- function(){
      arrow::open_dataset("/mnt/d/big_data/original_parquet_arrow/", format = "parquet")
}

dataset <- get_db()


