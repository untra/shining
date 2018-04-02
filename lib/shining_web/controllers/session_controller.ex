defmodule ShiningWeb.SessionController do
  use ShiningWeb, :controller

  alias Shining.Engine.{Player, Character}
  def new(conn, _) do
    conn
    |> render("new.html", changeset: %{})
  end

  # TODO: address no utf8 allowed
  def create(conn, %{
  "name" => player_name,
  }) do
    # TODO: remove this, implement as a form
    player_characters = [
      %Character{
        champion: true,
        exp: 10,
        level: 1,
        name: "The Mercenary",
        class: :mercenary,
        race: :ember,
        sex: false,
        equipment: [1001, 2021, nil],
        items: [32, 32, 32],
        skills: [],
        history: [],
        appearance: 0
      },
      %Character{
        champion: false,
        level: 1,
        name: "The Mage",
        class: :mage,
        race: :fey,
        sex: true,
        equipment: [1041, 2001, nil],
        items: [41, 51],
        skills: [],
        history: [],
        appearance: 0
      },
      %Character{
        champion: false,
        level: 1,
        name: "The Healer",
        class: :healer,
        race: :human,
        sex: false,
        equipment: [1071, 2011, nil],
        items: [11, 12, 1, 2],
        skills: [],
        history: [],
        appearance: 0
      },
      %Character{
        champion: false,
        level: 1,
        name: "The Archer",
        class: :archer,
        race: :human,
        sex: true,
        equipment: [1031, nil, nil],
        items: [11, 1],
        skills: [],
        history: [],
        appearance: 0
      },
    ]
    player = %Player{
      name: player_name,
      characters: player_characters,
      champion: nil,
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
