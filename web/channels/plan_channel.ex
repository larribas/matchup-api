defmodule Matchup.PlanChannel do
  use Phoenix.Channel

  def join("plan:" <> plan_id, _params, socket) do
    if Matchup.Behaviors.Plan.exists?(plan_id) do
      {:ok, socket}
    else
      {:error, %{reason: "not found"}}
    end
  end

  # Ping (for debugging reasons)
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Actions are handed to the domain, validated and broadcasted (if successful)
  def handle_in(action, payload, socket) do
    outcome = Matchup.Behaviors.Plan.action(action, payload)
    case outcome do
      {:ok, events} ->
        broadcast! socket, action, payload
        {:noreply, socket}
      {:error, errors} ->
        {:reply, {:error, errors}, socket}
    end
  end

end