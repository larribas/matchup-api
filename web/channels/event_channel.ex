defmodule Matchup.EventChannel do
  use Phoenix.Channel

  def join("event:" <> _event_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in(event, params, socket) do
    # TODO Use the configuration to decide which behavior to delegate to
    # TODO Delegate to that behavior (validates input, applies rules and changes the event's state, and returns (transformed?) event and params)
    broadcast! socket, event, params
    {:noreply, socket}
  end
end