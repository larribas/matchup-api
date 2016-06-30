defmodule Matchup.Shared.ComponentRegistryTest do
  use ExUnit.Case, async: true
  alias Matchup.Shared.ComponentRegistry, as: ComponentRegistry

  setup do
    ComponentRegistry.start
    ComponentRegistry.clear
    :ok
  end

  test "lookup something that does not exist" do
    :error = ComponentRegistry.lookup("x")
  end

  test "create and lookup" do
    component = %{port: "adapter"}
    ComponentRegistry.create("x", component)
    {:ok, ^component} = ComponentRegistry.lookup("x")
  end

end