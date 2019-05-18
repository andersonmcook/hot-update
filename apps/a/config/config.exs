# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :a, AWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fKDQqfflsxwG2bJm+AcKo1Ws4mSUysTfvpFe1pvXVLkU5teUz6KB7H1x5Zda/xmr",
  render_errors: [view: AWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: A.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
