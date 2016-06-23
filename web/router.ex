defmodule Matchup.Router do
  use Matchup.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/plans", Matchup do
    pipe_through :api

    post "/", PlansController, :create
    get "/", PlansController, :search
    get "/:id", PlansController, :show
  end
end
