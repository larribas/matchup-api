defmodule Matchup.Plans.TableSoccer.UseCases do

  def search(%{} = params, %{domain: domain, repository: repository, collection: collection}) do
    games = repository.search(collection, params)
    {:ok, games}
  end

  def create(%{"name" => name, "username" => username}, %{domain: domain, repository: repository, collection: collection}) do
    {game, events} = domain.create(name, username)

    repository.create(collection, game["id"], game)
    {:ok, game, events}
  end

  def join(%{"id" => id, "username" => username}, %{domain: domain, repository: repository, collection: collection, scheduler: scheduler, scheduler_instance: scheduler_instance} = state) do
    try do
      game = repository.read(collection, id)
      unless game, do: throw("game does not exist")

      {game, events} = game |> domain.join(username)

      if length(game["players"]) == 4 do
        {game, evs} = game |> domain.start
        events = events ++ evs

        # Free table automatically in 20 minutes
        scheduler.delay(scheduler_instance, __MODULE__, :free_table, [%{"id" => id}, state], 1000 * 60 * 20)
      end

      repository.update(collection, game["id"], game)
      {:ok, game, events}
    catch
      msg -> {:error, msg}
    end
  end

  def leave(%{"id" => id, "username" => username}, %{domain: domain, repository: repository, collection: collection}) do
    try do
      game = repository.read(collection, id)
      unless game, do: throw("game does not exist")

      {game, events} = game |> domain.leave(username)
    
      if game["players"] == [] do
       {game, evs} = game |> Domain.finish
       events = events ++ evs
      end

      repository.update(collection, game["id"], game)
      {:ok, game, events}
    catch
      msg -> {:error, msg}
    end
  end

  def free_table(params, %{domain: domain, repository: repository, collection: collection}) do
    try do
      games_being_played = case params do
        %{"id" => id} -> repository.search(collection, %{"id" => id, "status" => "playing"})
        _ -> repository.search(collection, %{"status" => "playing"})
      end

      {game, events} = case games_being_played do
        [game | others] -> game |> domain.finish
        _ -> {nil, []}
      end

      repository.update(collection, game["id"], game)
      {:ok, game, events}
    catch
      msg -> {:error, msg}
    end
  end
  
end