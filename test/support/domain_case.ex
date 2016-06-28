defmodule Matchup.DomainCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def assert_throws(expected_msg, f) do
        try do
          f.()
          refute "I shouldn't get here because something should have been thrown just before"
        catch
          msg -> assert msg == expected_msg
        end
      end

      def assert_events(events, types) do
        assert length(events) == length(types)
        assert Enum.map(events, fn ev -> ev["type"] end) == types
      end
    end
  end
    
end