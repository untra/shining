defmodule Shining.Engine.WorldServer do
  require Logger
  alias Shining.Engine.{HexCoordinates, WorldServer, WorldRules, Player, Character}

  def start_link(world_name, options) do
    GenServer.start_link(__MODULE__, {world_name, options}, name: via_tuple(world_name))
  end

  def init({world_name, options}) do
    world_config = Shining.World.init_config()
    # DynamicSupervisor.init(child_spec()[strategy: :one_for_one, name: Shining.Engine.WorldSupervisor])
    world = case :ets.lookup(:worlds_table, world_name) do
      [] -> Shining.World.new(world_config, options)
      [{^world_name, world}] -> world
    end
    :ets.insert(world_name, world)
    Logger.info("Spawned new world named '#{world_name}'")
    {:ok, world}
  end

  def via_tuple(world_name), do: {:via, Registry, {Registry.World, "#{world_name}"}}

  def add_player(world, player = %Player{}) do
    GenServer.call(world, {:add_player, player})
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

  def handle_cast({:player_enter, %Player{name: name, characters: characters, champion: champion} = player}, world) do
    Player.valid?(player)
    && characters |> Enum.map(&Character.valid?(&1))
    {:noreply, world}
  end

  def handle_cast({:character_enter, %Character{name: name} = character}, world) do
    Character.valid?(character)
    {:noreply, world}
  end

  def terminate({:shutdown, :timeout}, _world) do
    :ets.delete(:worlds_table, my_world_name())
    :ok
  end

  def terminate(_reason, _world) do
    :ok
  end

  defp my_world_name() do
    Registry.keys(Shining.WorldRegistry, self()) |> List.first
  end

  def pid(world_name) do
    case Registry.lookup(Shining.WorldRegistry, world_name) do
      [] -> nil
      [{pid, _}] -> pid
    end
  end

end
