# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_foo,
  ecto_repos: [ExFoo.Repo]

# Configures the endpoint
config :ex_foo, ExFooWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k3SZIdFvg9/yWnQee/0unEz3OzIcyy2r2ZBCDxVVeHeH49JFW3gI3obGDwNRTdun",
  render_errors: [view: ExFooWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ExFoo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
