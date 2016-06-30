defmodule Matchup.Shared.Repository.InMemoryTest do
  use ExUnit.Case, async: true
  import Matchup.RepositoryTestMacro

  test_repository Matchup.Shared.Repository.InMemory
end
