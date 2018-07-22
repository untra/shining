defmodule ShiningWeb.WorldController do
  use ShiningWeb, :controller

  plug :require_player

  alias Shining.Engine.{WorldSupervisor}

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"world_name" => world_name }) do
    # world_name = Shining.Utils.Haiku.generate()
    # world_atom = world_name |> String.to_atom()
    options = %{}
    case WorldSupervisor.start_world(world_name, options) do
      {:ok, _game_pid} ->
        redirect(conn, to: world_path(conn, :show, world_name))
      {:error, _error} ->
        conn
        |> put_flash(:error, "unable to start world!")
        |> redirect(to: world_path(conn, :new))
    end
  end

  def show(conn, %{"id" => world_id}) do
    IO.inspect(world_id)
    # case WorldSupervisor.pid(world_id) do
    #   pid when is_pid(pid) ->
    #     conn
    #     |> assign(:world_name, world_id)
    #     |> assign(:auth_token, generate_auth_token(conn))
    #     |> render("show.html")
    #   nil ->
    #     conn
    #     |> put_flash(:error, "game not found!")
    #     |> redirect(to: world_path(conn, :new))
    # end
    conn
    |> assign(:world_name, world_id)
    |> assign(:auth_token, generate_auth_token(conn))
    |> render("show.html")
  end

  # if the player has been setup, let them continue
  defp require_player(conn, _opts) do
    if get_session(conn, :current_player) do
      conn
    else
      # store the request_path to the session
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  defp generate_auth_token(_conn) do
    #TODO finish this
    nil
  end
end
