defmodule Matchup.PlanSocket do
  use Phoenix.Socket

  ## Channels
  channel "plan:*", Matchup.PlanChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
