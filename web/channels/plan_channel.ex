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
    outcome = query(socket, name, payload)
    {:reply, outcome, socket}
  end

  # Commands are handed to the domain, validated and processed. 
  #  - If successful, the resulting events will be broadcasted
  #  - Otherwise, the error will be sent to the client as a one-to-one reply
  def handle_in("command:" <> name, payload, socket) do
    try do
      case command(socket, name, payload) do
        {:ok, events} ->
          for %{type: type, params: params} <- events, do: broadcast socket, type, params
          {:noreply, socket}
        {:error, msg} ->
          {:reply, {:error, %{reason: msg}}, socket}
      end
    catch
      msg -> {:error, msg}
    end
  end

  def query(%{topic: "plan:" <> type}, name, payload) do
    component = case type do
      "table_soccer" ->
        Matchup.TableSoccer.Queries
      "dummy" ->
        Matchup.Dummy.Queries
    end

    apply(component, String.to_atom(type), [payload])
  end

  def command(%{topic: "plan:" <> type}, name, payload) do
    component = case type do
      "table_soccer" ->
        Matchup.TableSoccer.Commands
      "dummy" ->
        Matchup.Dummy.Commands
    end

    apply(component, String.to_atom(type), [payload])
  end

end