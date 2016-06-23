defmodule Event do
  def new(type, params) do
    %{"type" => type, "params" => params}
  end

  def new(type, entity, keys) do
    new(type, elem(Map.split(entity, keys), 0))
  end
end