defmodule Matchup.Mixfile do
  use Mix.Project

  def project do
    [app: :matchup,
     version: System.get_env("MATCHUP_VERSION"),
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: CoberturaCover],
     aliases: aliases,
     deps: deps]
  end

  def application do
    [mod: {Matchup, []},
     applications: [:phoenix, :cowboy, :logger, :mongodb, :poolboy]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.1.6"},
      {:cowboy, "~> 1.0"},
      {:uuid, "~> 1.1" },
      {:mongodb, "~> 0.1.1"},
      {:poolboy, "~> 1.5.1"},
      {:cobertura_cover, "~> 0.9.0", only: :test}
    ]
  end

  defp aliases do
    []
  end
end
