# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :shining,
  ecto_repos: [Shining.Repo]

# Configures the endpoint
config :shining, ShiningWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nclWqod5CYGaia09JzEfWCy0+oy/KzKOXG8YflJSjbHKXClfMIklvE9hQH5+Vv6i",
  render_errors: [view: ShiningWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Shining.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# TODO: remove this secret
config :shining, ShiningWeb.Guardian,
       issuer: "shining-0.0.1",
       secret_key: "Sc/HcZoiE+YNBVi8xox4ZN+WAbCWx2P0iJyqPSvzODuDkqWgCDrtWE+Yq5O0W7Iu"