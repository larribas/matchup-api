# Dummy behavior to help test the connection between channels and the domain. 
# It accepts queries and commands, and returns dummy values
defmodule Matchup.Behaviors.Dummy do

  def query(name, params) do
    {
      :ok, 
      %{name: name, params: params}
    }
  end

  def command(name, params) do
    {
      :ok, 
      [%Event{type: name, params: params}]
    }
  end

end