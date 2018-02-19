defmodule Shining.Engine.CharacterFSM do
  alias Shining.Engine.{HexCoordinates, Character, Player}

  def start_link(character), do:
    GenServer.start_link(__MODULE__, character, name: via_tuple(character))

  def init(character) do
    {:ok, Character.init_statusquo(character)}
  end

  def via_tuple(world_number), do: {:via, Registry, {Registry.World, "WORLD-#{world_number}"}}

  def handle_call({:add_player, player = %Player{}}, _from, state) do
    
  end

  # taking damage
  def handle_cast({:take_damage, damage}, state) do
    {:noreply, state}
  end

  # taking healing
  def handle_cast({:take_healing, healing}, state) do
    {:noreply, state}
  end

  # taking some status effect change
  def handle_cast({:take_effect, effect}, state) do
    {:noreply, state}
  end

end