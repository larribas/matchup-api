defmodule Matchup.TableSoccer do

  def port(name) do
    case name do
      :repository -> Matchup.Shared.Repositories.InMemory
      :scheduler -> Matchup.Shared.Schedulers.InMemory
    end
  end
  
end