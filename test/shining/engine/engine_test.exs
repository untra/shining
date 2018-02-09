defmodule Shining.EngineTest do
  use Shining.DataCase

  alias Shining.Engine

  describe " " do
    alias Shining.Engine.Character

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Engine.create_character()

      character
    end

    test "list_ /0 returns all  " do
      character = character_fixture()
      assert Engine.list_ () == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Engine.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Engine.create_character(@valid_attrs)
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, character} = Engine.update_character(character, @update_attrs)
      assert %Character{} = character
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_character(character, @invalid_attrs)
      assert character == Engine.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Engine.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Engine.change_character(character)
    end
  end

  describe "characters" do
    alias Shining.Engine.Character

    @valid_attrs %{class: 42, equipment: [], exp: 42, history: [], items: [], level: 42, name: "some name", race: 42, sex: true, skills: []}
    @update_attrs %{class: 43, equipment: [], exp: 43, history: [], items: [], level: 43, name: "some updated name", race: 43, sex: false, skills: []}
    @invalid_attrs %{class: nil, equipment: nil, exp: nil, history: nil, items: nil, level: nil, name: nil, race: nil, sex: nil, skills: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Engine.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Engine.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Engine.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Engine.create_character(@valid_attrs)
      assert character.class == 42
      assert character.equipment == []
      assert character.exp == 42
      assert character.history == []
      assert character.items == []
      assert character.level == 42
      assert character.name == "some name"
      assert character.race == 42
      assert character.sex == true
      assert character.skills == []
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, character} = Engine.update_character(character, @update_attrs)
      assert %Character{} = character
      assert character.class == 43
      assert character.equipment == []
      assert character.exp == 43
      assert character.history == []
      assert character.items == []
      assert character.level == 43
      assert character.name == "some updated name"
      assert character.race == 43
      assert character.sex == false
      assert character.skills == []
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_character(character, @invalid_attrs)
      assert character == Engine.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Engine.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Engine.change_character(character)
    end
  end
end
