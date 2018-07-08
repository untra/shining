defmodule Shining.Utils.Haiku do
  @spec generate() :: String.t
  def generate do
    [
      Enum.random(adjectives()),
      Enum.random(nouns()),
      :rand.uniform(9)
    ] |> Enum.join("-")
  end

  defp adjectives do
    ~w(
      autumn summer winter spring
    )
  end

  defp nouns do
    ~w(
      morning evening midday midnight
    )
  end
end
