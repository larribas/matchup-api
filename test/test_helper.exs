ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Matchup.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Matchup.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Matchup.Repo)

