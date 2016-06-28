defmodule Matchup.TableSoccer do

  def port(name) do
    case name do
      :repository -> Matchup.Shared.Repository.InMemory
      :scheduler -> Matchup.Shared.Scheduler.InMemory
      :event_log -> Matchup.Shared.EventLog.InMemory
    end
  end
  
end