defmodule Matchup.PlanChannelTest do
  use Matchup.ChannelCase

  setup do
    {:ok, _, socket} = socket("user_id", %{}) |> subscribe_and_join(Matchup.PlanChannel, "plan:dummy_plan")
    {:ok, socket: socket}
  end

  # TODO subscribing to nonexistent plan returns an error
  # TODO subscribing to a plan broadcasts all new events
  # TODO actions sent to a plan are forwarded to the appropriate behavior

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "queries are properly delegated", %{socket: socket} do
    params = %{"param": "something"}
    ref = push socket, "query:test", params
    assert_reply ref, :ok, %{"name": "test", "params": params}
  end

  test "commands are properly delegated", %{socket: socket} do
    params = %{"param": "something"}
    ref = push socket, "command:test", params
    assert_broadcast "test", params
  end

end
