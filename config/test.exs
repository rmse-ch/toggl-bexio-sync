import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :pbkdf2_elixir, :rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :toggl_bexio_sync, TogglBexioSync.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "toggl_bexio_sync_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :toggl_bexio_sync, TogglBexioSyncWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8eY0/8E1U8TM8+R56GjiPDc9SJUB/CyBsSd4arPvglrp2QqeCor3xSUNa7MO5i7i",
  server: false

# In test we don't send emails.
config :toggl_bexio_sync, TogglBexioSync.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
