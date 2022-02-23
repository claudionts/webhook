import Config

config :webhook, Webhook.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "postgres",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :webhook, WebhookWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "v8LXQHyWvmzzcvDeYLP25SsK1Q8HgvKEgiXvxg2VDO6IX4LSHCWWvTce2SwYHpze",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
