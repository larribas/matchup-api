defmodule Matchup.EventsController do
  use Matchup.Web, :controller

  def search(conn, _params) do
    conn |> send_resp(200, "searching for events!")
  end

  def show(conn, _params) do
    conn |> send_resp(200, "showing an event's info")
  end

  def create(conn, _params) do
    conn |> send_resp(201, "creating a new event!")
  end

end