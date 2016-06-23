defmodule Event do
  defstruct type: "event_type", params: %{}

  def new(type, params) do
    %Event{"type" => type, "params" => params}
  end

  def new(type, entity, keys) do
    new(type, elem(Map.split(entity, keys), 0))
  end
end