library (dplyr, quietly = TRUE, verbose = FALSE, warn.conflict = FALSE)
library (arrow, quietly = TRUE, verbose = FALSE, warn.conflict = FALSE)
library (DBI)
#library (duckdb)
library (glue)
library (purrr)

data_source <- "/mnt/d/big_data/original_csv.zip"
data_uncompressed <- "/mnt/d/big_data/original_csv_uncompressed"
#data_dest_folder <- "/mnt/d/big_data/original_parquet/"
data_dest_folder_arrow <- "/mnt/d/big_data/original_parquet_arrow/"

#con <- dbConnect(duckdb::duckdb(), dbdir = ":memory:")

# if (file.exists(data_uncompressed)) {
#   unlink(data_uncompressed,recursive = TRUE)
#   cat("Uncompressed directory has been deleted")
# }
# 
# unzip_result <- unzip(data_source, exdir = data_uncompressed)

list_of_files <- list.files(path = data_uncompressed,
                            recursive = TRUE,
                            pattern = "\\.csv$",
                            full.names = TRUE)

copy_files_arrow <- function (file) {
  data_dest <- glue({data_dest_folder_arrow}, stringr::str_extract(basename(file),  ".*\\."), "parquet")
  
  query <- read_csv_arrow(file, as_data_frame = FALSE)
  tf1 <- tempfile(fileext = ".parquet")
  write_parquet(query, data_dest)
  print(glue::glue(as.character(Sys.time()), " - ", {data_dest}))
  
}

Sys.time()

# Remove previous binary files
if (file.exists(data_dest_folder_arrow)) {
  unlink(data_dest_folder_arrow,recursive = TRUE)
  cat("Binary directory has been deleted")
}

purrr::map(list_of_files, ~copy_files_arrow(.))

Sys.time()

# list_of_files <- list.files(path = "/mnt/d/big_data/original_csv_uncompressed/original_csv",
#                             recursive = TRUE,
#                             pattern = "\\.parquet$",
#                             full.names = TRUE)
# 
# schema <- schema(
#   hvfhs_license_num = string(),
#   dispatching_base_num= string(),
#   pickup_datetime= timestamp(),
#   dropoff_datetime= timestamp(),
#   PULocationID= int64(),
#   DOLocationID= int64(),
#   SR_Flag= int64()
#   #year = int64(),
#   #month = int64()
# )
# 
# ds_list <- purrr::map (list_of_files, ~open_dataset(., schema=schema, format = "csv", partitioning = c("year", "month")))
# 
# ds <- open_dataset("/mnt/d/big_data/original_csv_uncompressed/original_csv/2020/01/", schema=schema, format = "csv")

