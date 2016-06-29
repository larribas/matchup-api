defmodule Matchup.TableSoccer.UseCasesTest do
  use ExUnit.Case, async: true
  use Matchup.DomainCase

  alias Matchup.Plans.TableSoccer, as: TableSoccer
  alias TableSoccer.UseCases, as: UseCases

  setup do
    # Get the standard configuration and (maybe) tweak it for testing    
    {:ok, component: Configuration.table_soccer}
  end

  test "create stores and returns a game and its events", %{component: component} do
    # The initial component is an empty set of games
    {:ok, games} = UseCases.search(%{}, component)
    assert Enum.empty?(games)

    # We create a new game
    {:ok, game, events} = UseCases.create(%{"name" => "Germany vs. Argentina", "username" => "Khedira"}, component)
    refute Enum.empty?(events)
    assert game["name"] == "Germany vs. Argentina"

    # Now that game is shown in the results
    {:ok, games} = UseCases.search(%{}, component)
    assert games == [game]

    # Two other people join the game and one leaves
    for player <- ["Messi", "Mascherano"], do: {:ok, _, _} = UseCases.join(%{"id" => game["id"], "username" => player}, component)
    {:ok, _, _} = UseCases.leave(%{"id" => game["id"], "username" => "Khedira"}, component)

    # Now the game has 2 players
    {:ok, [game|tail]} = UseCases.search(%{}, component)
    assert_contain_exactly game["players"], ["Messi", "Mascherano"]
    assert game["status"] == "queued"

    # Khedira tries to leave again, and that is an error
    {:error, _} = UseCases.leave(%{"id" => game["id"], "username" => "Khedira"}, component)

    # Another two German players join and the game starts
    for player <- ["Neuer", "Özil"], do: {:ok, _, _} = UseCases.join(%{"id" => game["id"], "username" => player}, component)
    {:ok, [game|t]} = UseCases.search(%{}, component)
    assert game["status"] == "playing"

    # We create another game and find two games when searching
    {:ok, _, _} = UseCases.create(%{"name" => "Spain vs. Italy", "username" => "Villa"}, component)
    {:ok, games} = UseCases.search(%{}, component)
    assert length(games) == 2

    # But if we search by status==playing, there is only one
    {:ok, games} = UseCases.search(%{"status" => "playing"}, component)
    assert games == [game]

    # Now we free the table and find that the game has been finished
    {:ok, game, events} = UseCases.free_table(%{}, component)
    assert game["status"] == "finished"
    {:ok, games} = UseCases.search(%{"status" => "playing"}, component)
    assert Enum.empty?(games)
  end

end
