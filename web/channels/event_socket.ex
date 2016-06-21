defmodule Matchup.EventSocket do
  use Phoenix.Socket

  ## Channels
  channel "event:*", Matchup.EventChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
