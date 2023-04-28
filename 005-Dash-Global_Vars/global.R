library (dplyr)
library (DBI)
library (duckdb)

# Environment Settings
Sys.setenv(DUCKDB_NO_THREADS = 2)
data_source <- "005-Dash-Global_Vars/data/mtcars.csv"
db_file <- "005-Dash-Global_Vars/data/my-db.duckdb"

# Create OLAP DBMS
con <- dbConnect(duckdb::duckdb(), dbdir = db_file, read_only = TRUE) 

# Import CSVs to DB

duckdb_read_csv(con, 
                "mtcars_tbl", file = data_source,
                delim = ";"
                )

dplyr::tbl(con, "mtcars_tbl") |> 
  select (car) |> 
  collect() 

dbDisconnect(con, shutdown = TRUE)



