defmodule Shining.Engine.Character do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shining.Engine.Character


  schema "characters" do
    field :class, :integer
    field :equipment, {:array, :integer}
    field :exp, :integer
    field :history, {:array, :integer}
    field :items, {:array, :integer}
    field :level, :integer
    field :name, :string
    field :race, :integer
    field :sex, :boolean, default: false
    field :skills, {:array, :integer}

    timestamps()
  end

  @doc false
  def changeset(%Character{} = character, attrs) do
    character
    |> cast(attrs, [:name, :class, :race, :sex, :exp, :level, :skills, :items, :equipment, :history])
    |> validate_required([:name, :class, :race, :sex, :exp, :level, :skills, :items, :equipment, :history])
  end
end
