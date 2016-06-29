defmodule Matchup.Shared.Repository.InMemoryTest do
  use ExUnit.Case, async: true
  use Matchup.DomainCase

  alias Matchup.Shared.Repository.InMemory, as: Repository

  setup do
    {:ok, artists} = Repository.start_link
    :ok = Repository.clear(artists)

    john =  %{"name" => "John Lennon", "band" => "Beatles"}
    yoko =  %{"name" => "Yoko Ono", "band" => "None"}

    :ok = Repository.create(artists, "john", john)
    :ok = Repository.create(artists, "yoko", yoko)

    {:ok, artists: artists, john: john, yoko: yoko}
  end

  test "#create and #read", %{artists: artists, john: john} do
    ^john = Repository.read(artists, "john")
  end

  test "#read nonexistent", %{artists: artists} do
    nil = Repository.read(artists, "missing")
  end

  test "#update and #read", %{artists: artists} do
    married_yoko = %{"band" => "Beatles"}
    :ok = Repository.update(artists, "yoko", married_yoko)
    ^married_yoko = Repository.read(artists, "yoko")
  end

  test "#update nonexistent", %{artists: artists} do
    :error = Repository.update(artists, "missing", %{"some" => "data"})
  end

  test "#search all", %{artists: artists, john: john, yoko: yoko} do
    results = Repository.search(artists)
    assert_contain_exactly results, [john, yoko]
  end

  test "#search by attribute", %{artists: artists, john: john} do
    results = Repository.search(artists, %{"name" => "John Lennon"})
    assert_contain_exactly results, [john]
  end

end
