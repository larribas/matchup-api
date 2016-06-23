defmodule Matchup.Behaviors.Plan do
  
  # TODO Queries: exists? search info

  def query("exists?", %{"id": id}) do
    # TODO Only the stored ones exist
    true
  end

  # TODO commands: create subscribe unsubscribe cancel

  def command("create", %{"name": name}) do
    {:ok, [event(:created, %{})]}
  end

  # TODO Extract to another module
  def event(type, params) do
    %{type: type, params: params}
  end

end