defmodule Matchup.PlanChannel do
  use Phoenix.Channel

  def join("plan:" <> type, _params, socket) do
    case Matchup.Shared.ComponentRegistry.lookup(type) do
      :error -> {:error, socket}
      _ -> {:ok, socket}
    end
  end

  # Ping (for debugging reasons)
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("use_case:" <> name, payload, socket) do
    case use_case(socket, name, payload) do
      {:ok, results} -> 
        {:reply, {:ok, %{"data" => results}}, socket}
      {:ok, result, events} ->
        for %{"type" => type, "params" => params} <- events, do: broadcast socket, type, params
        {:reply, {:ok, %{"data" => result}}, socket}
      {:error, msg} ->
        {:reply, {:error, %{"reason" => msg}}, socket}
    end
  end

  def use_case(%{topic: "plan:" <> type}, name, payload) do
    {:ok, component} = Matchup.Shared.ComponentRegistry.lookup(type)
    %{use_cases: use_case} = component
    apply(use_case, String.to_atom(name), [payload, component])
  end

end