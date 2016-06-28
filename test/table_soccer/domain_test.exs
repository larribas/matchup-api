defmodule Matchup.TableSoccer.DomainTest do
  use ExUnit.Case, async: true
  use Matchup.DomainCase
  
  import Matchup.TableSoccer.Support.Factory

  alias Matchup.TableSoccer.Domain, as: Domain

  test "create game" do
    {game, events} = Domain.create("some name", "me")
    %{"name" => "some name", "status" => "queued", "players" => ["me"]} = game
    assert_events events, ["created"]
  end

  test "join a game that is not on queue" do
    assert_throws "the game must be on queue", fn ->
      specific_game(%{"status" => "other"}) |> Domain.join("me") 
    end
  end

  test "join a game you are already playing" do
    assert_throws "you are already playing", fn ->
      specific_game(%{"players" => ["me"]}) |> Domain.join("me") 
    end
  end

  test "join a game when the game is complete" do
    assert_throws "the game is complete", fn ->
      specific_game(%{"players" => ["1", "2", "3", "4"]}) |> Domain.join("me") 
    end
  end

  test "join a game" do
    {game, events} = specific_game(%{"players" => []}) |> Domain.join("me")
    assert game["players"] == ["me"]
    assert_events events, ["joined"]
  end

  test "leave a game that is not on queue" do
    assert_throws "the game must be on queue", fn ->
      specific_game(%{"status" => "other", "players" => ["me"]}) |> Domain.leave("me") 
    end
  end

  test "leave a game when you are not playing" do
    assert_throws "you are not playing", fn ->
      specific_game(%{"players" => ["not me"]}) |> Domain.leave("me")
    end
  end

  test "leave a game" do
    {game, events} = specific_game(%{"players" => ["you", "me"]}) |> Domain.leave("me")
    assert game["players"] == ["you"]
    assert_events events, ["left"]
  end

  test "start a new game that is not on queue" do
    assert_throws "the game must be on queue", fn ->
      specific_game(%{"status" => "other"}) |> Domain.start 
    end
  end

  test "start a new game" do
    {game, events} = specific_game |> Domain.start
    assert game["status"] == "playing"
    assert_events events, ["started"]
  end

  test "finish a game" do
    {game, events} = specific_game |> Domain.finish
    assert game["status"] == "finished"
    assert_events events, ["finished"]
  end

end