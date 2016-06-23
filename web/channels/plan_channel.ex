defmodule Matchup.PlanChannel do
  use Phoenix.Channel

  def join("plan:" <> type, _params, socket) do
    {:ok, socket}
  end

  # Ping (for debugging reasons)
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Queries are handed to the domain, validated and returned to the user
  def handle_in("query:" <> name, payload, socket) do
    outcome = select_behavior(socket).query(name, payload)
    {:reply, outcome, socket}
  end

  # Commands are handed to the domain, validated and processed. 
  #  - If successful, the resulting events will be broadcasted
  #  - Otherwise, the error will be sent to the client as a one-to-one reply
  def handle_in("command:" <> name, payload, socket) do
    try do
      case select_behavior(socket).command(name, payload) do
        {:ok, events} ->
          for %Event{type: type, params: params} <- events, do: broadcast socket, type, params
          {:noreply, socket}
        {:error, msg} ->
          {:reply, {:error, %{reason: msg}}, socket}
      end
    catch
      msg -> {:error, msg}
    end
  end

  # Behavior selector for a socket
  def select_behavior(socket) do
    # TODO Make this a proper router (dependant on configuration)
    %{topic: "plan:" <> type} = socket
    case type do
      "table_soccer" ->
        Matchup.Behaviors.TableSoccer
      "dummy" ->
        Matchup.Behaviors.Dummy
      _ ->
        # TODO Implement generic plan management
        Matchup.Behaviors.Dummy
    end
  end

end