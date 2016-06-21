defmodule Matchup.PageControllerTest do
  use Matchup.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert response(conn, 200) =~ "searching for events!"
  end
end
