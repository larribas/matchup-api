defmodule Matchup do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Matchup.Endpoint, []),
      # Here you could define other workers and supervisors as children
      # worker(Matchup.Worker, [arg1, arg2, arg3]),
    ]

    # Configure component states
    Matchup.Shared.ComponentRegistry.start
    Matchup.Shared.ComponentRegistry.create("table_soccer", Configuration.table_soccer)

    opts = [strategy: :one_for_one, name: Matchup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Matchup.Endpoint.config_change(changed, removed)
    :ok
  end
end
