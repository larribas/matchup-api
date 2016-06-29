defmodule Matchup.Plans.TableSoccer.Support.Factory do
  def specific_game(params \\ %{}) do
    game = %{
      "id" => UUID.uuid4,
      "name" => "game name",
      "status" => "queued",
      "players" => ["player"],
      "started_at" => nil,
      "finished_at" => nil
    }

    Map.merge(game, params)
  end
end