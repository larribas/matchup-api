defmodule Matchup.Plan do
  
  def query("read", %{"id": id}) do
    # TODO
    {:ok, %{"id": id, "name": "unimplemented"}}
  end

  def query(other, _params) do
    {:error, "Query #{other} does not exist"}
  end

  def command(other, _params) do
    {:error, "Command #{other} does not exist"}
  end

end