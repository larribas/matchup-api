defmodule Matchup.TableSoccer.Commands do

  def create(%{"name" => name}) do
    {game, events} = create(name)

    # TODO Publish events
    {:ok, game, events}
  end

  def join(%{"id" => id, "username" => username}) do
    {game, events} = {Matchup.TableSoccer.port(:repository).read(id), []}
        |> exists!
        |> join(username)

    if length(game["players"]) == 4 do
      {game, events} = {game, events} |> start
      Matchup.TableSoccer.port(:scheduler).delay("free table", %{}, 1000 * 60 * 20)
    end

    # TODO Publish events
    {:ok, game, events}
  end

  def leave(%{"id" => id, "username" => username}) do
    {game, events} = {Matchup.TableSoccer.port(:repository).read(id), []}
        |> exists!
        |> leave(username)
    
    if length(game["players"]) == 0 do
      {game, events} = {game, events} |> cancel
    end

    # TODO Publish events
    {:ok, game, events}
  end

  def free_table(%{}) do
    games_being_played = Matchup.TableSoccer.port(:repository).search(%{"status" => "playing"})
    {game, events} = case games_being_played do
      [game | others] -> {game, []} |> finish
      _ -> {nil, []}
    end

    # TODO Publish events
    {:ok, game, events}
  end
  
end