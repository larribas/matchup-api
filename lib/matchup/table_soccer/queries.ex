defmodule Matchup.TableSoccer.Queries do

  def search(%{}) do
    games = Matchup.TableSoccer.port(:repository).search
    {:ok, games}
  end
  
end