defmodule Matchup.Shared.Repository.InMemory do

  def collection(_collection_name) do
    Agent.start_link(fn -> %{} end)
  end
  
  def create(collection, id, data) do
    Agent.update(collection, &Map.put(&1, id, data))
  end

  def read(collection, id) do
    Agent.get(collection, &Map.get(&1, id))
  end

  def update(collection, id, data) do
    if read(collection, id) do
      Agent.update(collection, &Map.put(&1, id, data))
    else
      :error
    end
  end

  def search(collection, params \\ %{}) do
    filter_algorithm = fn item ->
      Enum.all?(params, fn {k,v} -> item[k] == v end)
    end

    Agent.get(collection, &Enum.filter(Map.values(&1), filter_algorithm))
  end

  def clear(collection) do
    Agent.update(collection, fn _ -> %{} end)
  end

end