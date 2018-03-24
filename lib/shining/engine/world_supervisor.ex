defmodule Shining.Engine.WorldSupervisor do
  require Logger
  use DynamicSupervisor

  alias Shining.Engine.{WorldServer, Player}

  def start_link(world_name, options) do
    DynamicSupervisor.start_link(__MODULE__, {world_name, options}, name: __MODULE__)
  end

  def init({world_name, _options}) do
    world = case :ets.lookup(:worlds_table, world_name) do
      [] -> %{}
      [{^world_name, world}] -> world
    end
    :ets.insert(world_name, world)
    Logger.info("Spawned new world named '#{world_name}'")
    DynamicSupervisor.init([strategy: :one_for_one, name: Shining.Engine.WorldSupervisor])
  end

  def start_world(world_name, options) do
    child_spec = %{
      id: WorldServer,
      start: {WorldServer, :start_link, [world_name, options]},
      restart: :transient
    }
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop_world(world_name) do
    :ets.delete(:worlds_table, world_name)
    child_pid = WorldServer.pid(world_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end

  def player_enter(%Player{name: name} = player) do
    # player_ok = validate(player)
    # characters_ok = validate(player.characters)
    # player_ok && characters_ok
    # :ets.insert_new(name, player)
    # child
  end

  def character_enter(character_name) do

  end

  def area_enter(area_name) do

  end

  def player_leave(player_name) do

  end

  def character_leave(character_name) do

  end

  def area_leave(area_name) do

  end

  def player_input() do
    # TODO:
    nil
  end

  def character_input() do
    # TODO:
    nil
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
