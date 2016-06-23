defmodule Matchup.TableSoccer.Listener do
  
  # TODO Listen to TableSoccer events and send them to the handler

  def handle(%{"type" => type, "params" => params}) do
    case type do
      "created" -> Matchup.TableSoccer.port(:repository).create(params["id"], params)
      _ -> 
        game = Matchup.TableSoccer.port(:repository).read(params["id"])
        Matchup.TableSoccer.port(:repository).update(params["id"], %{game | params})
    end
    
  end

end