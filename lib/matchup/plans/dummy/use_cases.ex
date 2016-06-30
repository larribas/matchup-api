defmodule Matchup.Plans.Dummy.UseCases do  
  def success(%{"answer" => answer}, _state) do
    {:ok, answer}
  end

  def success_with_events(%{"answer" => answer, "events" => events}, _state) do
    {:ok, answer, events}
  end

  def error(%{"msg" => msg}, _state) do
    {:error, msg}
  end
end