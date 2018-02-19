defmodule Shining.Engine.Character do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shining.Engine.Character
  alias Shining.Accounts.User

  @type race :: :human | :fey | :ember | :canid | :centaur | :ratman | :avis | :undead | :plant | :machine
  @races [:human, :fey, :ember, :canid, :centaur, :ratman, :avis, :undead, :plant, :machine]


  schema "characters" do
    field :class, :integer
    field :equipment, {:array, :integer}
    field :exp, :integer
    field :history, {:array, :string}
    field :items, {:array, :integer}
    field :level, :integer
    field :name, :string
    field :race, :integer
    field :sex, :boolean, default: false
    field :champion, :boolean, default: false
    field :skills, {:array, :integer}
    belongs_to :user, User
    # virtual fields
    field :statusquo, :map, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Character{} = character, attrs) do
    character
    |> cast(attrs, [:name, :class, :race, :sex, :exp, :level, :skills, :items, :equipment, :history])
    |> validate_required([:name, :class, :race, :sex, :exp, :level, :skills, :items, :equipment, :history])
  end

  defp init_statusquo(%Character{} = character) do
    max_hp = getMaxHP(character)
    %{character | statusquo: %{
      maxHP: max_hp,
      curHP: max_hp,
      maxSP: getMaxSP(character),
      curSP: getInitSP(character),
      maxAP: getMaxAP(character),
      curAP: 0,
      curStatus: {:ok, %{}},
      curATKmod: 0,
      curDEFmod: 0,
      curACCmod: 0,
      curEVAmod: 0,
      studiedBy: [],
      fsmState: :readying,
      fsmAnticipating: {:ready, 1000}
    }}
  end

  defp getMaxHP(%Character{} = character) do
    champion_hp = if character.champion, do: 5, else: 0
    init_race_hp = race_stats[character.race][:init_hp]
    incr_race_hp = race_stats[character.race][:incr_hp]
    leveled_hp = character.level * incr_race_hp
    # TODO: get class hp
    champion_hp + init_race_hp + leveled_hp
  end

  defp getMaxSP(%Character{} = character) do
    champion_sp = if character.champion, do: 5, else: 0
    init_race_sp = race_stats[character.race][:init_sp]
    incr_race_sp = race_stats[character.race][:incr_sp]
    leveled_sp = character.level * incr_race_sp
    # TODO: get class sp
    champion_sp + init_race_sp + leveled_sp
  end

  defp getInitSP(%Character{} = character) do
    max_sp = getMaxSP(character)
    case character.race do
      :ratman -> max_sp
      :avis -> round(max_sp/2)
      :centaur -> round(max_sp/2)
      _ -> 0
    end
  end

  defp getMaxAP(%Character{} = character) do
    race_stats[character.race][:ap_per_turn]
  end

  defp race_stats(), do: %{
    human:    %{init_hp: 60, init_sp: 40, incr_hp: 6, incr_sp: 4, init_atk: 5, init_def: 2, movement: 5, ap_per_turn: 20_000},
    fey:      %{init_hp: 50, init_sp: 50, incr_hp: 3, incr_sp: 8, init_atk: 5, init_def: 2, movement: 5, ap_per_turn: 20_000},
    ember:    %{init_hp: 50, init_sp: 50, incr_hp: 8, incr_sp: 3, init_atk: 5, init_def: 2, movement: 5, ap_per_turn: 20_000},
  }

end
