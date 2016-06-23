defmodule Matchup.PlanChannel do
  use Phoenix.Channel

  def join("plan:" <> plan_id, _params, socket) do
    case Matchup.Plan.query("read", %{"id": plan_id}) do
      {:ok, _plan} ->
        {:ok, socket}
      {:error, errors} ->
        {:error, %{reason: "not found", errors: errors}}
    end
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
    outcome = select_behavior(socket).command(name, payload)
    case outcome do
      {:ok, events} ->
        for %Event{type: type, params: params} <- events do
           broadcast socket, type, params
        end
        
        {:noreply, socket}
      {:error, errors} ->
        {:reply, {:error, errors}, socket}
    end
  end

  # Behavior selector for a socket
  def select_behavior(socket) do
    # TODO Make this a proper router (dependant on configuration)
    if Mix.env == :test do
      Matchup.Behaviors.Dummy
    else
      Matchup.Behaviors.TableSoccer
    end
  end

end