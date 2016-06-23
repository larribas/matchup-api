defmodule Matchup.Dummy.Commands do
  
  def dummy(params) do
    {
      :ok, 
      [Event.new("dummied", params)]
    }
  end

end