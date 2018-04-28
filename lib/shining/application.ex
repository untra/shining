defmodule Shining.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    alias Shining.Engine.WorldSupervisor
    alias Shining.NameServer

    # Define workers and child supervisors to be supervised
    children = [
      # {Registry, keys: :unique, name: Shining.AreaRegistry},
      # {Registry, keys: :unique, name: Shining.PlayerRegistry},
      # {Registry, keys: :unique, name: Shining.CharacterRegistry},
      {Registry, keys: :unique, name: Shining.WorldRegistry},
      WorldSupervisor,
      NameServer,

      # Start the Ecto repository
      # TODO: commented out to disable connections to postgres db
      # supervisor(Shining.Repo, []),
      # Start the endpoint when the application starts
      # TODO: commented out
      supervisor(ShiningWeb.Endpoint, []),
      # Start your own worker by calling: Shining.Worker.start_link(arg1, arg2, arg3)
      # worker(Shining.Worker, [arg1, arg2, arg3]),
    ]

    :ets.new(:worlds_table, [:public, :named_table])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shining.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShiningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
