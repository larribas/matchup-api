defmodule Matchup.PlansControllerTest do
  use Matchup.ConnCase

  test "GET /plans", %{conn: conn} do
    conn = get conn, "/plans"
    assert true
  end
end
