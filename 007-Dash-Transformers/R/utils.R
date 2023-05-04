get_do_locations <- function (data, location){

  data |>
    select (dispatching_base_num, DOLocationID) |>
    dplyr::filter(dispatching_base_num == location) |>
    distinct(DOLocationID) |>
    #distinct(lubridate::date(pickup_datetime)) |>
    dplyr::collect() |>
    pull()

}

get_locations <- function (data){
  
  data |> dplyr::distinct(dispatching_base_num) |> dplyr::collect() |> dplyr::pull()
  
}