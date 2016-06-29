defmodule Matchup.Shared.Scheduler.InMemoryTest do
  use ExUnit.Case, async: true
  use Matchup.DomainCase

  alias Matchup.Shared.Scheduler.InMemory, as: Scheduler

  def execute(pid, msg) do
    send pid, "executed: #{msg}"
  end

  setup do
    {:ok, scheduler} = Scheduler.start_link
    {:ok, scheduler: scheduler}
  end

  test "a job delayed for 10 milliseconds gets executed after timeout", %{scheduler: scheduler} do
    Scheduler.delay(scheduler, Matchup.Shared.Scheduler.InMemoryTest, :execute, [self, "milliseconds"], 10)

    executed = receive do
      "executed: milliseconds" -> true
    after 1000 -> false
    end
      

    assert executed
  end

  test "a job delayed for 10 hours does not get executed after timeout", %{scheduler: scheduler} do
    Scheduler.delay(scheduler, Matchup.Shared.Scheduler.InMemoryTest, :execute, [self, "hours"], 1000 * 60 * 60)

    executed = receive do
      "executed: hours" -> true
    after 1000 -> false
    end

    refute executed
  end

end