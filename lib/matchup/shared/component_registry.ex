defmodule Matchup.Shared.ComponentRegistry do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  def create(name, component) do
    GenServer.cast(__MODULE__, {:create, name, component})
  end

  def clear do
    GenServer.cast(__MODULE__, {:clear})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, registry) do
    {:reply, Map.fetch(registry, name), registry}
  end

  def handle_cast({:create, name, component}, registry) do
    if Map.has_key?(registry, name) do
      {:noreply, registry}
    else
      {:noreply, Map.put(registry, name, component)}
    end
  end

  def handle_cast({:clear}, _registry) do
    {:noreply, %{}}
  end

end