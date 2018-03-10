defmodule Shining.Engine.WorldSupervisor do
  use Supervisor

  alias Shining.Engine.{WorldFSM}

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Supervisor.init(child_spec()[strategy: :one_for_one, name: Shining.Engine.WorldSupervisor])
  end

  def start_world(world_name, size) do
    child_spec = %{
      id: WorldFSM,
      start: {WorldFSM, :start_link, [world_name, size]}
      restart: :transient
    }
  end

  def stop_world(world_name) do
    child_pid = WorldFSM.pid(world_name)
    Supervisor.terminate_child(__MODULE__, child_pid)
  end

  def player_enter(player_name) do

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

end
