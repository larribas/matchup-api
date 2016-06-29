defmodule Matchup.TableSoccer.Commands do
  import Matchup.TableSoccer
  alias Matchup.TableSoccer.Domain, as: Domain

  def create(%{"name" => name}) do
    {game, events} = Domain.create(name)

    port(:event_log).publish("table_soccer_events", events)
    {:ok, game, events}
  end

  def join(%{"id" => id, "username" => username}) do
    try do
      {game, events} = {port(:repository).read(id), []} |> Domain.join(username)

      if length(game["players"]) == 4 do
        {game, events} = {game, events} |> Domain.start

        # Free table automatically in 20 minutes
        port(:scheduler).delay(Matchup.TableSoccer.Commands, :free_table, [%{"id" => id}], 1000 * 60 * 20)
      end

      port(:event_log).publish("table_soccer_events", events)
      {:ok, game, events}
    catch
      msg -> {:error, msg}
    end
  end

  def leave(%{"id" => id, "username" => username}) do
    try do
      {game, events} = {port(:repository).read(id), []} |> Domain.leave(username)
    
      if length(game["players"]) == 0, do: {game, events} = {game, events} |> Domain.finish

      port(:event_log).publish("table_soccer_events", events)
      {:ok, game, events}
    catch
      msg -> {:error, msg}
    end
  end

  def free_table(params) do
    try do
      games_being_played = case params do
        %{"id" => id} -> port(:repository).search(%{"id" => id, "status" => "playing"})
        _ -> port(:repository).search(%{"status" => "playing"})
      end

      {game, events} = case games_being_played do
        [game | others] -> {game, []} |> Domain.finish
        _ -> {nil, []}
      end

      port(:event_log).publish("table_soccer_events", events)
      {:ok, game, events}
    catch
      msg -> {:error, msg}
    end
  end
  
end