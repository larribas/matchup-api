defmodule Matchup.Plans.TableSoccer.Domain do
  alias Matchup.Shared.Event, as: Event
  
  def create(name, username) do
    game = %{
      "id" => UUID.uuid4,
      "name" => name,
      "status" => "queued",
      "players" => [username],
      "started_at" => nil,
      "finished_at" => nil
    }
    events = [Event.new("created", game)]

    {game, events}
  end

  def join(game, username) do
    %{"players" => players, "status" => status} = game
    unless status == "queued", do: throw("the game must be on queue")
    if length(players) == 4, do: throw("the game is complete")
    if Enum.find(players, fn(player) -> player == username end), do:  throw("you are already playing")

    game = %{game | "players" => [username | players]}
    events = [Event.new("joined", game, ["id", "players"])]
    {game, events}
  end

  def leave(game, username) do
    %{"players" => players, "status" => status} = game
    unless status == "queued", do: throw("the game must be on queue")
    unless Enum.find(players, fn(player) -> player == username end), do: throw("you are not playing")

    game = %{game | "players" => Enum.reject(players, fn(player) -> player == username end)}
    events = [Event.new("left", game, ["id", "players"])]
    {game, events} 
  end

  def start(game) do
    %{"status" => status} = game
    unless status == "queued", do: throw("the game must be on queue")

    game = %{game | "status" => "playing", "started_at" => :os.system_time(:milli_seconds)}
    events = [Event.new("started", game, ["id", "status", "started_at"])]
    {game, events}
  end

  def finish(game) do
    game = %{game | "status" => "finished", "finished_at" => :os.system_time(:milli_seconds)}
    events = [Event.new("finished", game, ["id", "status", "finished_at"])]
    {game, events}    
  end

end