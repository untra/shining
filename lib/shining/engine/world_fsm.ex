defmodule Shining.Engine.WorldFSM do
  alias Shining.Engine.{HexCoordinates, WorldFSM, WorldRules, Player}

  def start_link(world_number) when is_integer(world_number), do:
    GenServer.start_link(__MODULE__, world_number, name: via_tuple(world_number))

  def init(world_number) do
    {:ok, %{world_number: world_number, players: [], areas: []}}
  end

  def via_tuple(world_number), do: {:via, Registry, {Registry.World, "WORLD-#{world_number}"}}

  def add_player(game, player = %Player{}) do
    GenServer.call(game, {:add_player, player})
  end

  # def handle_call({:add_player, player = %Player{}}, _from, state) do
  #   with {:ok, rules} <- WorldRules.check(state, :add_player, player)
  #   do
  #     state
  #     |> update_player2_name(name)
  #     |> update_rules(rules)
  #     |> reply_success(:ok)
  #   else
  #     :error -> {:reply, :error, state_data}
  #   end
  # end
            
end