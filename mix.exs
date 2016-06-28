defmodule Matchup.Mixfile do
  use Mix.Project

  def project do
    [app: :matchup,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [mod: {Matchup, []},
     applications: [:phoenix, :cowboy, :logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.1.6"},
     {:cowboy, "~> 1.0"},
     { :uuid, "~> 1.1" }
   ]
  end

  defp aliases do
    []
  end
end
