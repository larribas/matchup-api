defmodule Matchup.Shared.Repository.Mongodb.Pool do
  use Mongo.Pool, name: __MODULE__, adapter: Mongo.Pool.Poolboy
end