defmodule Shining.Engine.CharacterFSM do
  alias Shining.Engine.{HexCoordinates, Character}

  def start_link do
    Task.start_link(fn -> loop(%Character{}) end)
  end



  defp loop(state) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(state, key)
        loop(state)
      {:put, key, value} ->
        loop(Map.put(state, key, value))
    after
      50 -> loop(state)
    end
  end
end