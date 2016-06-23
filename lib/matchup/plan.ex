defmodule Matchup.Plan do

  # Queries: read, search (list), show
  
  def query("read", %{"id": id}) do
    # TODO
    {:ok, %{"id": id, "name": "unimplemented"}}
  end

  def query(other, _params) do
    {:error, "Query #{other} does not exist"}
  end


  # Commands: create, subscribe, unsubscribe, cancel

  def command(other, _params) do
    {:error, "Command #{other} does not exist"}
  end

end