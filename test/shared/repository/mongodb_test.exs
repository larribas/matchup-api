defmodule Matchup.Shared.Repository.MongodbTest do
  use ExUnit.Case, async: true
  import Matchup.RepositoryTestMacro

  setup do
    Configuration.mongodb
    :ok
  end

  test_repository Matchup.Shared.Repository.Mongodb
end
