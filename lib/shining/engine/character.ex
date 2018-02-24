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
    field :appearance, :integer
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

  def isDead?(%Character{statusquo: %{curHP: curHP}}) when curHP >  0, do: true
  def isDead?(%Character{statusquo: %{curHP: curHP}}) when curHP <= 0, do: false

  def calculateATK(%Character{} = character) do
    (1 + raceAtk(character)
    + classAtk(character)
    + weaponAtk(character)) * appliedAtkMod(character)
  end

  def calculateDEF(%Character{} = character) do
    (1 + raceDef(character)
    + classDef(character)
    + armorDef(character)) * appliedDefMod(character)
  end

  def calculateCritical?(luck, strike, %Character{} = attacker, %Character{} = target)
  when is_float(luck) and is_map(strike) do
    # (with skill) +15% crit chance when in danger, +30% when in critical
    # something here with attacker and target . luck?
    crit_chance = Map.get(strike, :crit_chance)
    crit_init = 0.095
    luck > crit_init * crit_chance
  end

  def calculateHit?(luck, strike, %Character{} = attacker, %Character{} = target)
  when is_float(luck) and is_map(strike) do
    # 50% hit chance when attacker is in danger, 25% hit chance when in critical
    target_evasion = appliedAccMod(attacker) - appliedEvaMod(target)
    hit_chance = Map.get(strike, :hit_chance)
    hit_init = 0.95
    luck > hit_init + (hit_chance - 1.0) + target_evasion
  end

  def calculateDamage(strike, %Character{} = attacker, %Character{} = target) do
    damage = Map.get(strike, :damage)
    (calculateATK(attacker) - calculateDEF(target)) * damage
    |> Float.ceil
    |> max(0)
    |> min(255)
  end

  # TODO: move this logic to the phazer frontend
  def canEquip?(%Character{} = character, item) do
    %{
      consumable: fn (_) -> false end,
      armor: fn (armor) -> canEquipArmor?(character, armor) end,
      weapon: fn (weapon) -> canEquipWeapon?(character, weapon) end,
      bonus: fn(_) -> false end,
    }[item.type].(item.specifically)
  end

  # TODO: move this logic to the phazer frontend
  defp canEquipArmor?(%Character{} = character, %{kind: kind}) do
    armor_permissions[kind]
    |> Enum.member(character.race)
  end

  # TODO: move this logic to the phazer frontend
  defp canEquipWeapon?(%Character{} = character, %{kind: kind}) do
    weapon_permissions[kind]
    |> Enum.member(character.class)
  end


  def init_statusquo(%Character{} = character) do
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

  defp appliedAtkMod(%Character{statusquo: %{curATKmod: curATKmod}}), do: appliedBounds(curATKmod)
  defp appliedDefMod(%Character{statusquo: %{curDEFmod: curDEFmod}}), do: appliedBounds(curDEFmod)
  defp appliedAccMod(%Character{statusquo: %{curACCmod: curACCmod}}), do: appliedBounds(curACCmod)
  defp appliedEvaMod(%Character{statusquo: %{curEVAmod: curEVAmod}}), do: appliedBounds(curEVAmod)

  defp appliedBounds(stat) do
    [0.25, 0.4, 0.55, 0.70, 0.85, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0]
    |> Enum.at(min(max(stat + 5,-5),5))
  end

  defp weaponAtk(%Character{equipment: []}), do: 0
  defp weaponAtk(%Character{equipment: equipment}) do
    equipment
    |> Enum.map(&(&1.specifically.atk))
    |> Enum.sum()
  end

  defp armorDef(%Character{equipment: []}), do: 0
  defp armorDef(%Character{equipment: equipment}) do
    equipment
    |> Enum.map(&(&1.specifically.def))
    |> Enum.sum()
  end

  defp getMaxHP(%Character{} = character) do
    champion_hp = if character.champion, do: 5, else: 0
    1 + champion_hp
    + race_stats[character.race][:init_hp]
    + (race_stats[character.race][:incr_hp] * character.level)
    + class_stats[character.class][:init_hp]
    + (class_stats[character.class][:incr_hp] * character.level)
  end

  defp getMaxSP(%Character{} = character) do
    champion_sp = if character.champion, do: 5, else: 0
    1 + champion_sp
    + race_stats[character.race][:init_sp]
    + (race_stats[character.race][:incr_sp] * character.level)
    + class_stats[character.class][:init_sp]
    + (class_stats[character.class][:incr_sp] * character.level)
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

  defp getMaxAP(%Character{} = character), do: race_stats[character.race][:ap_per_turn]

  defp raceAtk(%Character{} = character), do: race_stats[character.race][:init_atk]
  defp raceDef(%Character{} = character), do: race_stats[character.race][:init_def]
  defp classAtk(%Character{} = character), do: class_stats[character.class][:init_atk]
  defp classDef(%Character{} = character), do: class_stats[character.class][:init_def]

  defp armor_permissions(), do: %{
    armor_robes: [:human, :fey, :canid, :ratman, :undead],
    armor_light: [:fey, :ember, :ratman, :avis, :undead],
    armor_heavy: [:human, :ember, :canid, :centaur, :undead],
  }

  defp weapon_permissions(), do: %{
    weapon_sword: [:mercenary],
    weapon_axe: [:mercenary],
    weapon_spear: [:mercenary],
    weapon_staff: [:mages, :healers],
    weapon_bow: [:archer]
  }

  defp race_stats(), do: %{
    human:    %{init_hp: 60, init_sp: 40, incr_hp: 6, incr_sp: 4, init_atk: 5, init_def: 2, movement: 5, ap_per_turn: 20_000, armors: [:armor_light, :armor_robes, :armor_heavy]},
    fey:      %{init_hp: 50, init_sp: 50, incr_hp: 3, incr_sp: 8, init_atk: 5, init_def: 2, movement: 5, ap_per_turn: 20_000, armors: [:armor_light, :armor_robes]},
    ember:    %{init_hp: 50, init_sp: 50, incr_hp: 8, incr_sp: 3, init_atk: 5, init_def: 2, movement: 5, ap_per_turn: 20_000, armors: [:armor_light, :armor_heavy]},
  }

  defp class_stats(), do: %{
    mercenary: %{init_hp: 4, init_sp: 2, incr_hp: 2, incr_sp: 1, init_atk: 3, init_def: 1,  weapons: [:weapon_spear, :weapon_axe, :weapon_sword]},
    healer:    %{init_hp: 3, init_sp: 3, incr_hp: 2, incr_sp: 1, init_atk: 0, init_def: 3, weapons: [:weapon_staff]},
    archer:    %{init_hp: 3, init_sp: 3, incr_hp: 1, incr_sp: 2, init_atk: 3, init_def: 0, weapons: [:weapon_bow]},
    mage:      %{init_hp: 2, init_sp: 4, incr_hp: 1, incr_sp: 2, init_atk: 2, init_def: 2}, weapons: [:weapon_staff],
  }

  defp next_level_exp(), do: [0, 5, 15, 25, 40, 60, 80, 100, 125, 150, 175, 205, 235, 270, 310, 350]
end
