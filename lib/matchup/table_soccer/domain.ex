defmodule Matchup.TableSoccer.Domain do
  
  def create(name) do
    game = %{
      "id" => UUID.uuid4,
      "name" => name,
      "status" => "queued",
      "players" => []
    }
    events = [Event.new("created", game)]

    {game, events}
  end

  def exists!({{:ok, game}, events}), do: {game, events}
  def exists!({{:error, msg}, _events}), do: throw(msg)

  def join({game, events}, username) do
    %{"players" => players} = game
    if length(players) == 4, do: throw("the game is complete")
    if Enum.find(players, fn(player) -> player == username end), do:  throw("you are already playing")

    game = %{game | "players" => [username | players]}
    events = events ++ [Event.new("joined", game, ["id", "players"])]
    {game, events}
  end

  def leave({game, events}, username) do
    %{"players" => players} = game
    unless Enum.find(players, fn(player) -> player == username end), do: throw("you are not playing")

    game = %{game | "players" => Enum.reject(players, fn(player) -> player == username end)}
    events = events ++ [Event.new("left", game, ["id", "players"])]
    {game, events} 
  end

  def start({game, events}) do
    game = %{game | "status" => "playing", "started_at" => :os.system_time(:milli_seconds)}
    events = events ++ [Event.new("started", game, ["id", "status", "started_at"])]
    {game, events}
  end

  def finish({game, events}) do
    game = %{game | "status" => "finished", "finished_at" => :os.system_time(:milli_seconds)}
    events = events ++ [Event.new("finished", game, ["id", "status", "finished_at"])]
    {game, events}    
  end

  def cancel({game, events}) do
    game = %{game | "status" => "canceled", "canceled_at" => :os.system_time(:milli_seconds)}
    events = events ++ [Event.new("canceled", game, ["id", "status", "canceled_at"])]
    {game, events}    
  end


end