defmodule Matchup.Shared.Repository.Mongodb do
  alias Matchup.Shared.Repository.Mongodb.Pool, as: Pool

  def collection(collection_name) do
    {:ok, collection_name}
  end
  
  def create(collection, id, data) do
    {:ok, _} = Pool |> Mongo.insert_one(collection, Map.merge(data, %{"_id" => id}))
    :ok
  end

  def read(collection, id) do
    case Pool |> Mongo.find(collection, %{"_id" => id}, projection: %{"_id" => 0}) |> Enum.to_list do
      [h|_] -> h
      _ -> nil
    end
  end

  def update(collection, id, data) do
    {:ok, %Mongo.UpdateResult{matched_count: count}} = Pool |> Mongo.replace_one(collection, %{"_id" => id}, data)
    case count do
      0 -> :error
      _ -> :ok
    end
  end

  def search(collection, params \\ %{}) do
    Pool |> Mongo.find(collection, params, projection: %{"_id" => 0}) |> Enum.to_list
  end

  def clear(collection) do
    {:ok, _} = Pool |> Mongo.delete_many(collection, %{})
    :ok
  end

end