defmodule Shining.Engine.Player do
  @enforce_keys [:user_id]
  defstruct [:user_id, :characters, :champion]

  def valid?(%Player{characters: characters, champion: champion}) do
    party_not_empty = Enum.empty?(characters)
    champion_in_party = Enum.member(characters, champion)
    party_not_empty && champion_in_party
  end

  def party_level(%Player{characters: characters, champion: champion}) do
    # champions level is intentionally double-counted
    [champion | characters]
    |> Enum.map(&(&1.level))
    |> mean()
  end

  defp mean(list) when length(list) == 0, do: 0
  defp mean(list), do: Enum.sum(list) / Enum.length(list)
end