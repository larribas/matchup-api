defmodule Matchup.Router do
  use Matchup.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/events", Matchup do
    pipe_through :api

    post "/", EventsController, :create
    get "/", EventsController, :search
    get "/:id", EventsController, :show
  end
end
