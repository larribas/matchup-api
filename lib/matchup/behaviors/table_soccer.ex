defmodule Matchup.Behaviors.TableSoccer do
  
  # We need to
  #  - remove the game when the last person unsubscribes

  #
  # QUERIES
  #

  def query("search", _params) do
    games = repository.search
    {:ok, games}
  end


  #
  # COMMANDS
  #

  def command("create", %{"name" => name}) do
    {game, events} = create(name)
    repository.create(game["id"], game)

    {:ok, events}
  end

  def command("join", %{"id" => id, "username" => username}) do
    {game, events} = {repository.read(id), []}
        |> exists!
        |> join(username)

    if length(game["players"]) == 4 do
      {game, events} = {game, events} |> start
      scheduler.delay("free table", %{}, 1000 * 60 * 20)
    end

    repository.update(id, game)
    {:ok, events}
  end

  def command("leave", %{"id" => id, "username" => username}) do
    {game, events} = {repository.read(id), []}
        |> exists!
        |> leave(username)
        |> cancel_if_empty

    repository.update(id, game)
    {:ok, events}
  end

  def command("free table", _) do
    case repository.search(%{"status" => "playing"}) do
      [game | others] ->
        {game, events} = {game, []} |> finish
        repository.update(game["id"], game)
        {:ok, events}
      _ ->
        {:ok, []}
    end
  end

  #
  # DOMAIN
  #

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



  #
  # INTERNAL (TODO: move to config)
  #

  def repository do
    # TODO Choose depending on configuration
    Matchup.Repositories.InMemory
  end

  def scheduler do
    # TODO Choose depending on configuration
    Matchup.Schedulers.InMemory
  end

end