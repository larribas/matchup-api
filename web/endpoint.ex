defmodule Matchup.Endpoint do
  use Phoenix.Endpoint, otp_app: :matchup

  socket "/socket", Matchup.PlanSocket

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Poison
end
