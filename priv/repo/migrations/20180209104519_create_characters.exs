defmodule Shining.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :class, :integer
      add :race, :integer
      add :appearance, :integer
      add :sex, :boolean, default: false, null: false
      add :champion, :boolean, default: false, null: false
      add :exp, :integer
      add :level, :integer
      add :skills, {:array, :integer}
      add :items, {:array, :integer}
      add :equipment, {:array, :integer}
      add :history, {:array, :string}

      timestamps()
    end

  end
end
