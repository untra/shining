defmodule Shining.Skills do
    def get(id) when is_integer(id), do: all() |> Enum.find(fn(x) -> Map.get(x, :id) == id end)
    def get(id, alt) when is_integer(id), do: get(id) || alt
    def all() do
        [ # Natural Abilities
        %{id: 10, name: "Human SP", value: 1, trigger: :damage_given, type: :natural, specifically: %{race: :human, kind: :sp_restore, heals_sp: :half}},
        %{id: 20, name: "Fey SP",   value: 1, trigger: :when_ready,  type: :natural, specifically: %{race: :fey, kind: :sp_restore, heals_sp: 3}},
        %{id: 30, name: "Ember SP", value: 1, trigger: :damage_taken, type: :natural, specifically: %{race: :ember, kind: :sp_restore, heals_sp: :match}},
        # Mercenary
        %{id: 1000, name: "Nurse Wounds", value: 1, trigger: :target_ally_self, type: :active, specifically: %{kind: :hp_restore, sp_cost: 5, range: 1, heals_hp: 10, heals_self_hp: 5}},
        %{id: 1050, name: "Power Attack", value: 1, trigger: :target_enemy, type: :active, specifically: %{kind: :mercenary_attack, sp_cost: 8, range: 1, damage: 1.25}},
        # Healer
        %{id: 2000, name: "Turniquot", value: 1, trigger: :target_ally, type: :active, specifically: %{kind: :sp_restore, heals_sp: :half}},
        # Archer
        %{id: 3000, name: "Human SP", value: 1, trigger: :damage_given, type: :natural, specifically: %{kind: :sp_restore, heals_sp: :half}},
        # Magic
        %{id: 10000, name: "Fire 1", value: 1, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_fire, sp_cost:  8, area: 1, range: 2, damage: 1.0, details: []}},
        %{id: 10001, name: "Fire 2", value: 2, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_fire, sp_cost: 20, area: 2, range: 3, damage: 0.75, details: []}},
        %{id: 10002, name: "Fire 3", value: 3, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_fire, sp_cost: 34, area: 1, range: 4, damage: 2.0, details: [:chance_50_burn]}},
        %{id: 10003, name: "Fire 4", value: 4, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_fire, sp_cost: 50, area: 2, range: 4, damage: 1.5, details: [:chance_50__burn]}},
        %{id: 10010, name: "Ice 1", value: 1, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_ice, sp_cost:  8, area: 2, range: 3, damage: 0.5, details: []}},
        %{id: 10011, name: "Ice 2", value: 2, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_ice, sp_cost: 20, area: 1, range: 3, damage: 1.5, details: []}},
        %{id: 10012, name: "Ice 3", value: 3, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_ice, sp_cost: 34, area: 2, range: 4, damage: 1.25, details: [:chance_50_freeze]}},
        %{id: 10013, name: "Ice 4", value: 4, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_ice, sp_cost: 50, area: 1, range: 4, damage: 2.25, details: [:chance_50_freeze]}},
        %{id: 10020, name: "Lightning 1", value: 1, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_lightning, sp_cost:  8, area: 1, range: 3, damage: 0.75, details: []}},
        %{id: 10021, name: "Lightning 2", value: 2, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_lightning, sp_cost: 20, area: 1, range: 4, damage: 1.25, details: [:chance_10_blind]}},
        %{id: 10022, name: "Lightning 3", value: 3, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_lightning, sp_cost: 34, area: 1, range: 5, damage: 1.75, details: [:chance_20_blind]}},
        %{id: 10023, name: "Lightning 4", value: 4, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_lightning, sp_cost: 50, area: 1, range: 6, damage: 2.50, details: [:chance_30_blind]}},
        %{id: 10030, name: "Heal 1", value: 1, trigger: :target_ally, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_heal, sp_cost:  6, area: 1, range: 2, heals_hp: 15, details: []}},
        %{id: 10031, name: "Heal 2", value: 2, trigger: :target_ally, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_heal, sp_cost: 15, area: 1, range: 3, heals_hp: 35, details: []}},
        %{id: 10032, name: "Heal 3", value: 3, trigger: :target_ally, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_heal, sp_cost: 25, area: 1, range: 4, heals_hp: 55, details: []}},
        %{id: 10033, name: "Heal 4", value: 4, trigger: :target_ally, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_heal, sp_cost: 36, area: 1, range: 5, heals_hp: 80, details: []}},
        %{id: 10040, name: "Blessing 1", value: 1, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_heal, sp_cost: 34, area: 2, range: 3, heals_hp: 20, details: []}},
        %{id: 10041, name: "Blessing 1", value: 1, trigger: :target_tile_suggest, type: :magical, specifically: %{kind: :elem_magic, elem: :elem_heal, sp_cost: 20, area: 1, range: 3, heals_hp: 25, details: []}}
    ]
    end
end