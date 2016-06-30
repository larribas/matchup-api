defmodule Matchup.PlanChannelTest do
  use Matchup.ChannelCase

  setup do
    Matchup.Shared.ComponentRegistry.create("dummy", Configuration.dummy)
    {:ok, _, socket} = socket("user_id", %{}) |> subscribe_and_join(Matchup.PlanChannel, "plan:dummy")
    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "successful use cases are properly delegated", %{socket: socket} do
    ref = push socket, "use_case:success", %{"answer" => "something"}
    assert_reply ref, :ok,  %{"data" => "something"}
  end

  test "successful use cases with events are properly delegated", %{socket: socket} do
    params = %{
      "answer" => "something", 
      "events" => [Matchup.Shared.Event.new("created", %{"event" => "params"})]
    }
    ref = push socket, "use_case:success_with_events", params
    assert_reply ref, :ok, params
    assert_broadcast "created", %{"event" => "params"}
  end

  test "failed use cases are properly delegated", %{socket: socket} do
    ref = push socket, "use_case:error", %{"msg" => "error!"}
    assert_reply ref, :error, %{"reason" => "error!"}
  end
  
end
