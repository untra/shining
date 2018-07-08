defmodule Shining.Engine.WorldSupervisor do
  require Logger
  use DynamicSupervisor

  alias Shining.Engine.{WorldServer, Player, Character}

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # def start_world(world_name, options) when is_bitstring(world_name), do: start_world(String.to_atom(world_name), options)
  def start_world(world_name, options) when is_bitstring(world_name) do
    child_spec = %{
      id: WorldServer,
      start: {WorldServer, :start_link, [world_name, options]},
      restart: :transient
    }
    world = case :ets.lookup(:worlds_table, world_name) do
      [] -> %{}
      [{^world_name, world}] -> world
    end
    :ets.insert(:worlds_table, {world_name, world})
    Logger.info("Spawned new world named '#{world_name}'")
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop_world(world_name) do
    :ets.delete(:worlds_table, :worlds_table, world_name)
    child_pid = pid(world_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end

  def player_enter(_world_pid, %Player{name: name} = player) do
    # TODO: validate characters (consider developing as protocol)
    # player_ok = validate(player)
    # characters_ok = validate(player.characters)
    # player_ok && characters_ok
    case :ets.insert_new(Player.snowflake(player), player) do
      false -> # already exists
        {:error, %{reason: "player #{name} is already in this world"}}
      _ -> # success
        {:ok, player}
    end
  end

  def character_enter(_world_pid, character_name, character_conf) do
    character = case Character.init_character(character_conf) do
      {:error, _} ->
        nil
      {:ok, character} ->
        character
    end
    case :ets.insert_new(Character.snowflake(character_conf), character) do
      false -> # already exists
        {:error, %{reason: "character #{character_name} is already in this world"}}
      _ -> # success
        {:ok, character}
    end
  end


  def area_enter(world_pid, {x, y, z}) do

  end

  def player_leave(world_pid, player_name) do

  end

  def character_leave(world_pid, character_name) do

  end

  def area_leave(world_pid, {x,y,z}) do

  end

  def area_summary(world_pid, {x,y,z}) do
    #
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
