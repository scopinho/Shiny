library(sodium)


user_base <- tibble::tibble(
  user = c("user1", "user2"),
  password = purrr::map_chr(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)


saveRDS(user_base, "Dash-Simple-Auth-001/user_base.rds")
