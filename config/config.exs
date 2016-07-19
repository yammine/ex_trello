use Mix.Config

config :ex_trello, :oauth, [
  app_key:             System.get_env("TRELLO_APP_KEY"),
  app_secret:          System.get_env("TRELLO_APP_SECRET"),
  access_token:        System.get_env("TRELLO_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TRELLO_ACCESS_SECRET")
]
