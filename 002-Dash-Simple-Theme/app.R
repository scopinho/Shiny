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
    DT::DTOutput("table"),
    plotOutput("plot")
  )
  
)

#################################################
theme <- bslib::bs_theme(version = 5)

ui <- navbarPage(
  theme = theme,
  title = "Dashboard Exemplo",
  id = "tabs", # must give id here to add/remove tabs in server
  collapsible = TRUE,
  login_tab
)

server <- function(input, output, session) {
  # Seletor de temas
  ###bslib::bs_themer()
  bslib::bs_theme_update(theme, font_scale = NULL,bootswatch = "united")


  thematic::thematic_shiny()
  
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
  
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
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
      
      output$plot <- renderPlot({
        ggplot(mtcars, aes(wt, mpg)) +
          geom_point() +
          geom_smooth()
      }, res = 96)
      
      # render data tab title and table depending on permissions
      user_permission <- credentials()$info$permissions
      if (user_permission == "admin") {
        output$data_title <- renderUI(tags$h2("Storms data. Permissions: admin"))
        
        output$table <- DT::renderDT({ 
          dplyr::storms[1:100, 1:11]},
          filter = "top"
          )
      } else if (user_permission == "standard") {
        output$data_title <- renderUI(tags$h2("Starwars data. Permissions: standard"))
        output$table <- DT::renderDT({ dplyr::starwars[, 1:10] })
      }
    }
  })
}

shinyApp(ui = ui, server = server)
