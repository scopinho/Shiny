# More details here:

# https://paulc91.github.io/shinyauthr/
  
library(shiny)
library(dplyr)
library(lubridate)
library(DBI)
library(RSQLite)

if (file.exists("my_db_file")) {
  db <- dbConnect(SQLite(), "my_db_file")
} else {
  db <- dbConnect(SQLite(), "my_db_file")
  dbCreateTable(db, "sessionids", c(user = "TEXT", sessionid = "TEXT", login_time = "TEXT"))
}

cookie_expiry <- 7

add_sessionid_to_db <- function(user, sessionid, conn = db) {
  tibble(user = user, sessionid = sessionid, login_time = as.character(now())) %>%
    dbWriteTable(conn, "sessionids", ., append = TRUE)
}

get_sessionids_from_db <- function(conn = db, expiry = cookie_expiry) {
  dbReadTable(conn, "sessionids") %>%
    mutate(login_time = ymd_hms(login_time)) %>%
    as_tibble() %>%
    filter(login_time > now() - days(expiry))
}

# dataframe that holds usernames, passwords and other user data

user_base <-  readRDS("user_base.rds")


#################################################
# login tab ui to be rendered on launch
login_tab <- tabPanel(
  title = icon("lock"), 
  value = "login", 
  shinyauthr::loginUI("login", "Autenticação", "Usuário", "Senha", error_message = "Usuário ou Senha inválido!")
)

# additional tabs to be added after login
home_tab <- tabPanel(
  title = icon("user"),
  value = "home",
  column(
    width = 12, 
    tags$h2("User Information"),
    verbatimTextOutput("user_data")
  )
)

data_tab <- tabPanel(
  title = icon("table"),
  value = "data",
  column(
    width = 12, 
    uiOutput("data_title"),
    DT::DTOutput("table")
  )
)

#################################################

ui <- navbarPage(
  title = "Dashboard Exemplo",
  id = "tabs", # must give id here to add/remove tabs in server
  collapsible = TRUE,
  login_tab
)

# ui <- fluidPage(
#   # add logout button UI
#   div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
#   # add login panel UI function
#   shinyauthr::loginUI(id = "login", cookie_expiry = cookie_expiry),
#   # setup table output to show user info after login
#   tableOutput("user_table"),
#   
#   selectInput("dataset", label="Dataset", choices = ls("package:datasets")),
#   verbatimTextOutput("summary"),
#   tableOutput("table")
# )

server <- function(input, output, session) {
  
  # hack to add the logout button to the navbar on app launch 
  insertUI(
    selector = ".navbar .container-fluid .navbar-collapse",
    ui = tags$ul(
      class="nav navbar-nav navbar-right",
      tags$li(
        div(
          style = "padding: 10px; padding-top: 8px; padding-bottom: 0;",
          shinyauthr::logoutUI("logout")
        )
      )
    )
  )
  
  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  # call login module supplying data frame, 
  # user and password cols and reactive trigger
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE,
    cookie_logins = TRUE,
    sessionid_col = sessionid,
    cookie_getter = get_sessionids_from_db,
    cookie_setter = add_sessionid_to_db,
    reload_on_logout = TRUE,
    log_out = reactive(logout_init())
  )
  
  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  observeEvent(credentials()$user_auth, {
    # if user logs in successfully
    if (credentials()$user_auth) { 
      # remove the login tab
      removeTab("tabs", "login")
      # add home tab 
      appendTab("tabs", home_tab, select = TRUE)
      # render user data output
      output$user_data <- renderPrint({ dplyr::glimpse(credentials()$info) })
      # add data tab
      appendTab("tabs", data_tab)
      # render data tab title and table depending on permissions
      user_permission <- credentials()$info$permissions
      if (user_permission == "admin") {
        output$data_title <- renderUI(tags$h2("Storms data. Permissions: admin"))
        output$table <- DT::renderDT({ dplyr::storms[1:100, 1:11] })
      } else if (user_permission == "standard") {
        output$data_title <- renderUI(tags$h2("Starwars data. Permissions: standard"))
        output$table <- DT::renderDT({ dplyr::starwars[, 1:10] })
      }
    }
  })
}

shinyApp(ui = ui, server = server)
