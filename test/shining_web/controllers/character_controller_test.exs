defmodule ShiningWeb.CharacterControllerTest do
  use ShiningWeb.ConnCase

  alias Shining.Engine

  @create_attrs %{class: 42, equipment: [], exp: 42, history: [], items: [], level: 42, name: "some name", race: 42, sex: true, skills: []}
  @update_attrs %{class: 43, equipment: [], exp: 43, history: [], items: [], level: 43, name: "some updated name", race: 43, sex: false, skills: []}
  @invalid_attrs %{class: nil, equipment: nil, exp: nil, history: nil, items: nil, level: nil, name: nil, race: nil, sex: nil, skills: nil}

  def fixture(:character) do
    {:ok, character} = Engine.create_character(@create_attrs)
    character
  end

  describe "index" do
    test "lists all characters", %{conn: conn} do
      conn = get conn, character_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Characters"
    end
  end

  describe "new character" do
    test "renders form", %{conn: conn} do
      conn = get conn, character_path(conn, :new)
      assert html_response(conn, 200) =~ "New Character"
    end
  end

  describe "create character" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, character_path(conn, :create), character: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == character_path(conn, :show, id)

      conn = get conn, character_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Character"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, character_path(conn, :create), character: @invalid_attrs
      assert html_response(conn, 200) =~ "New Character"
    end
  end

  describe "edit character" do
    setup [:create_character]

    test "renders form for editing chosen character", %{conn: conn, character: character} do
      conn = get conn, character_path(conn, :edit, character)
      assert html_response(conn, 200) =~ "Edit Character"
    end
  end

  describe "update character" do
    setup [:create_character]

    test "redirects when data is valid", %{conn: conn, character: character} do
      conn = put conn, character_path(conn, :update, character), character: @update_attrs
      assert redirected_to(conn) == character_path(conn, :show, character)

      conn = get conn, character_path(conn, :show, character)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, character: character} do
      conn = put conn, character_path(conn, :update, character), character: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Character"
    end
  end

  describe "delete character" do
    setup [:create_character]

    test "deletes chosen character", %{conn: conn, character: character} do
      conn = delete conn, character_path(conn, :delete, character)
      assert redirected_to(conn) == character_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, character_path(conn, :show, character)
      end
    end
  end

  defp create_character(_) do
    character = fixture(:character)
    {:ok, character: character}
  end
end
