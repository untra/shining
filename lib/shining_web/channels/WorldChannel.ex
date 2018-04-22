defmodule ShiningWeb.WorldChannel do
  use ShiningWeb, :channel

  alias Shining.Engine.WorldSupervisor

  def join("world:" <> world_name, _params, socket) do
    case WorldSupervisor.pid(world_name) do
      pid when is_pid(pid) ->
        send(self(), {:after_join, world_name})
        {:ok, socket}

      nil ->
        {:error, %{reason: "Game doesn't exist"}}
    end
  end

  def handle_info({:after_join, world_name}, socket) do
    summary = WorldSupervisor.summary(world_name)

    push(socket, "world_summary", summary)

    # push(socket, "presence_state", Presence.list(socket))

    # {:ok, _} =
    #   Presence.track(socket, current_player(socket).name, %{
    #     online_at: inspect(System.system_time(:seconds)),
    #     color: current_player(socket).color
    #   })

    {:noreply, socket}
  end

  def handle_in("mark_square", %{"phrase" => phrase}, socket) do
    {:reply, {:error, %{reason: "World doesn't listen in!"}}, socket}
  end

  def handle_in("request_area", %{"x" => x, "y" => y, "z" => z}, socket)
  when is_integer(x) and is_integer(y) and is_integer(z) do
    world_pid = "123"
    area = WorldSupervisor.area_summary(world_pid, {x,y,z})
    reply(socket, area)
  end
  def handle_in("request_area", params, socket), do:
    {:reply, {:error, %{reason: "bad input to request_area: #{inspect(params)}"}}, socket}

  defp current_player(socket) do
    socket.assign.current_player
  end
end
