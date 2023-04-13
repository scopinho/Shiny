library(sodium)


user_base <- tibble::tibble(
  user = c("user1", "user2"),
  password = purrr::map_chr(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("Usuario 1", "Usuario 2")
)


saveRDS(user_base, "002-Dash-Simple-Theme/user_base.rds")
