library(sodium)


user_base <- tibble::tibble(
  user = c("user1", "user2"),
  password = purrr::map_chr(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("User 1", "User 2")
)


saveRDS(user_base, "003-Dash-Dashboard/user_base.rds")