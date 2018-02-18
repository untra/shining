defmodule Shining.Engine.WorldRules do
  alias Shining.Engine.{Player}

  def check(state, :add_player) do
    # a player will be added if:
    # there is room for the player on the map

  end

  def check(state, :add_player, player = %Player{}) do
    party_level = Player.party_level(player)
    Player.valid?(player)
    && world_leveled_available?(state, party_level)
  end

  defp world_leveled_available?(state, level) do
    # TODO: ask the world manager if theres an available drop-in
    # area that can accept a characater at this level
  end


            
end