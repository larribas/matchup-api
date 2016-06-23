defmodule Matchup.Behaviors.Plan do
  
  # TODO Queries: search info

  def query(other, _params) do
    {:error, "Query #{other} does not exist"}
  end

  # TODO commands: create subscribe unsubscribe cancel

  def command(other, _params) do
    {:error, "Command #{other} does not exist"}
  end

  # TODO Extract to another module
  def event(type, params) do
    %{type: type, params: params}
  end

end