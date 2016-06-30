defmodule Configuration do

  def mongodb do
    mongo_opts = for {k,v} <- %{
      hostname: System.get_env("MONGODB_HOST"),
      database: System.get_env("MONGODB_DBNAME") || "matchup",
      username: System.get_env("MONGODB_USERNAME"),
      password: System.get_env("MONGODB_PASSWORD")
    }, v != nil, do: {k,v}
    
    pool = case Matchup.Shared.Repository.Mongodb.Pool.start_link(mongo_opts) do
      {:ok, pool} -> pool
      {:error, {:already_started, pool}} -> pool
    end

    %{pool: pool}
  end

  def table_soccer do
    # Start up Mongo
    mongodb
    
    {:ok, collection} = Matchup.Shared.Repository.Mongodb.collection("table_soccer")
    {:ok, scheduler_instance} = Matchup.Shared.Scheduler.InMemory.start_link

    %{
      use_cases: Matchup.Plans.TableSoccer.UseCases,
      domain: Matchup.Plans.TableSoccer.Domain,
      repository: Matchup.Shared.Repository.Mongodb,
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