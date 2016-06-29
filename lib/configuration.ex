defmodule Configuration do

  def table_soccer do
    {:ok, collection} = Matchup.Shared.Repository.InMemory.start_link
    {:ok, scheduler_instance} = Matchup.Shared.Scheduler.InMemory.start_link

    %{
      use_cases: Matchup.Plans.TableSoccer.UseCases,
      domain: Matchup.Plans.TableSoccer.Domain,
      repository: Matchup.Shared.Repository.InMemory,
      collection: collection,
      scheduler: Matchup.Shared.Scheduler.InMemory,
      scheduler_instance: scheduler_instance
    }
  end

  def dummy do
    %{
      use_cases: Matchup.Plans.Dummy.UseCases
    }
  end
  
end