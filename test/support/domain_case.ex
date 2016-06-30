defmodule Matchup.DomainCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def assert_throws(expected_msg, f) do
        try do
          f.()
          refute expected_msg
        catch
          msg -> assert msg == expected_msg
        end
      end

      def assert_events(events, types) do
        assert length(events) == length(types)
        assert Enum.map(events, fn ev -> ev["type"] end) == types
      end

      def assert_contain_exactly(actual, expected) do
        assert length(expected) == length(actual)
        for item <- expected, do: assert Enum.member?(actual, item)
      end
    end
  end

end