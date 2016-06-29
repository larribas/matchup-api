defmodule Matchup.Shared.Scheduler.InMemory do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def delay(instance, module, function, params, time) do
    Process.send_after(instance, {:execute, module, function, params}, time)
  end

  #
  # Server-side code
  #

  def handle_info({:execute, module, function, params}, state) do
    apply(module, function, params)
    {:noreply, state}
  end
  
end