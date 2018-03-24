defmodule ShiningWeb.SessionController do
  use ShiningWeb, :controller

  alias Shining.Engine.Player
  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => %{
  "player_name" => player_name,
  "player_characters" => player_characters
  }}) do
    player = %Player{
      name: player_name,
      characters: player_characters,
      champion: player_characters[0],
      user_id: 0
    }
    conn
    |> put_session(:current_player, player)
    |> redirect_back_or_to_new_game
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_player)
    |> redirect(to: "/")
  end

  defp redirect_back_or_to_new_game(conn) do
    path = get_session(conn, :return_to) || world_path(conn, :new)

    conn
    |> put_session(:return_to, nil)
    |> redirect(to: path)
  end
end
