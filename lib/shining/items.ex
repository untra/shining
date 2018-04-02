defmodule Shining.Items do
# Champions:
# 0 - none
# 1 - initial: +20% ATK and DEF for 2-area around champion, including champion
# 2 - team atk + 1 at match start (bounty +20)
# 3 - team def + 1 at match start (bounty +20)
# 4 - team spd + 5% (bounty +20)
# 5 - team regen 3 HP at start of turn (bounty +50)
# 6 - team immune to status changes (bounty +50)
# 7 - team members move with teleportation (bounty +50)
# 8 - (unlocked after beating the light wizard) (bounty +100)
# 9 - (unlocked after beating the dark wizard) (bounty +100)
# 10 - (unlocked at level 15) (bounty +200)
#    - your location is known to the game world
#    - team atk & def +2 at match start
#    - team spd + 10%
    def get(id) when is_integer(id), do: all() |> Enum.find(fn(x) -> Map.get(x, :id) == id end)
    def get(id, alt) when is_integer(id), do: get(id) || alt
    def all() do
    [
        %{id: 0, name: "Error Artifact", value: 1, type: :key, specifically: %{kind: :error}},
        %{id: 1, name: "Herb 1", value: 1, type: :consumable, specifically: %{kind: :item_herb, heals_hp: 3}},
        %{id: 2, name: "Herb 2", value: 2, type: :consumable, specifically: %{kind: :item_herb, heals_hp: 5}},
        %{id: 3, name: "Herb 3", value: 3, type: :consumable, specifically: %{kind: :item_herb, heals_hp: 8}},
        %{id: 4, name: "Herb 4", value: 4, type: :consumable, specifically: %{kind: :item_herb, heals_hp: 12}},
        %{id: 11, name: "flower 1", value: 1, type: :consumable, specifically: %{kind: :item_flower, heals_sp: 6}},
        %{id: 12, name: "flower 2", value: 2, type: :consumable, specifically: %{kind: :item_flower, heals_sp: 13}},
        %{id: 13, name: "flower 3", value: 3, type: :consumable, specifically: %{kind: :item_flower, heals_sp: 21}},
        %{id: 14, name: "flower 4", value: 4, type: :consumable, specifically: %{kind: :item_flower, heals_sp: 30}},
        %{id: 20, name: "Rotten Flesh", value: 0, type: :consumable, specifically: %{kind: :item_rawmeat, deliver_status: :poison}},
        %{id: 21, name: "Raw Meat 1", value: 1, type: :consumable, specifically: %{kind: :item_rawmeat, heals_hp: 2}},
        %{id: 22, name: "Raw Meat 2", value: 2, type: :consumable, specifically: %{kind: :item_rawmeat, heals_hp: 4}},
        %{id: 23, name: "Raw Meat 3", value: 3, type: :consumable, specifically: %{kind: :item_rawmeat, heals_hp: 6}},
        %{id: 24, name: "Raw Meat 4", value: 4, type: :consumable, specifically: %{kind: :item_rawmeat, heals_hp: 8}},
        %{id: 31, name: "Cooked Meat 1", value: 1, type: :consumable, specifically: %{kind: :item_cookedmeat, heals_hp: 10}},
        %{id: 32, name: "Cooked Meat 2", value: 2, type: :consumable, specifically: %{kind: :item_cookedmeat, heals_hp: 20}},
        %{id: 33, name: "Cooked Meat 3", value: 3, type: :consumable, specifically: %{kind: :item_cookedmeat, heals_hp: 30}},
        %{id: 34, name: "Cooked Meat 4", value: 4, type: :consumable, specifically: %{kind: :item_cookedmeat, heals_hp: 40}},
        %{id: 41, name: "Potion 1", value: 1, type: :consumable, specifically: %{kind: :item_potion, heals_hp: 20}},
        %{id: 42, name: "Potion 2", value: 2, type: :consumable, specifically: %{kind: :item_potion, heals_hp: 45}},
        %{id: 43, name: "Potion 3", value: 3, type: :consumable, specifically: %{kind: :item_potion, heals_hp: 80}},
        %{id: 44, name: "Potion 4", value: 4, type: :consumable, specifically: %{kind: :item_potion, heals_hp: 120}},
        %{id: 51, name: "elixir 1", value: 1, type: :consumable, specifically: %{kind: :item_elixir, heals_sp: 15}},
        %{id: 52, name: "elixir 2", value: 2, type: :consumable, specifically: %{kind: :item_elixir, heals_sp: 30}},
        %{id: 53, name: "elixir 3", value: 3, type: :consumable, specifically: %{kind: :item_elixir, heals_sp: 45}},
        %{id: 54, name: "elixir 4", value: 4, type: :consumable, specifically: %{kind: :item_elixir, heals_sp: 60}},
        %{id: 61, name: "apples", value: 1, type: :consumable, specifically: %{kind: :item_fruit, restores_percentage: 4}},
        %{id: 62, name: "grapes", value: 2, type: :consumable, specifically: %{kind: :item_fruit, restores_percentage: 8}},
        %{id: 63, name: "Pears", value: 3, type: :consumable, specifically: %{kind: :item_fruit, restores_percentage: 12}},
        %{id: 64, name: "watermelon", value: 4, type: :consumable, specifically: %{kind: :item_fruit, restores_percentage: 16}},
        %{id: 71, name: "Restore 1", value: 1, type: :consumable, specifically: %{kind: :item_restore, restores_percentage: 20}},
        %{id: 72, name: "Restore 2", value: 2, type: :consumable, specifically: %{kind: :item_restore, restores_percentage: 30}},
        %{id: 73, name: "Restore 3", value: 3, type: :consumable, specifically: %{kind: :item_restore, restores_percentage: 40}},
        %{id: 74, name: "Restore 4", value: 4, type: :consumable, specifically: %{kind: :item_restore, restores_percentage: 50}},
        #
        %{id: 100, name: "Vine Poison", value: 1, type: :consumable, specifically: %{kind: :item_buff, buff: :poison_attack}},
        %{id: 100, name: "Ectoplasm", value: 1, type: :consumable, specifically: %{kind: :item_buff, buff: :invisibility}},
        # Weapons
        %{id: 1001, name: "Sword 1", value: 1, type: :weapon, specifically: %{kind: :weapon_sword, atk: 3}},
        %{id: 1002, name: "Sword 2", value: 2, type: :weapon, specifically: %{kind: :weapon_sword, atk: 5}},
        %{id: 1003, name: "Sword 3", value: 3, type: :weapon, specifically: %{kind: :weapon_sword, atk: 8}},
        %{id: 1004, name: "Sword 4", value: 4, type: :weapon, specifically: %{kind: :weapon_sword, atk: 10}},
        %{id: 1005, name: "Sword 5", value: 5, type: :weapon, specifically: %{kind: :weapon_sword, atk: 13}},
        %{id: 1011, name: "Axe 1", value: 1, type: :weapon, specifically: %{kind: :weapon_axe, atk: 4}},
        %{id: 1012, name: "Axe 2", value: 2, type: :weapon, specifically: %{kind: :weapon_axe, atk: 7}},
        %{id: 1013, name: "Axe 3", value: 3, type: :weapon, specifically: %{kind: :weapon_axe, atk: 9}},
        %{id: 1014, name: "Axe 4", value: 4, type: :weapon, specifically: %{kind: :weapon_axe, atk: 11}},
        %{id: 1015, name: "Axe 5", value: 5, type: :weapon, specifically: %{kind: :weapon_axe, atk: 14}},
        %{id: 1021, name: "Spear 1", value: 1, type: :weapon, specifically: %{kind: :weapon_spear, atk: 2}},
        %{id: 1022, name: "Spear 2", value: 2, type: :weapon, specifically: %{kind: :weapon_spear, atk: 4}},
        %{id: 1023, name: "Spear 3", value: 3, type: :weapon, specifically: %{kind: :weapon_spear, atk: 6}},
        %{id: 1024, name: "Spear 4", value: 4, type: :weapon, specifically: %{kind: :weapon_spear, atk: 9}},
        %{id: 1025, name: "Spear 5", value: 5, type: :weapon, specifically: %{kind: :weapon_spear, atk: 12}},
        %{id: 1031, name: "Bow 1", value: 1, type: :weapon, specifically: %{kind: :weapon_bow, atk: 1, range: 3, }},
        %{id: 1032, name: "Bow 2", value: 2, type: :weapon, specifically: %{kind: :weapon_bow, atk: 3, range: 4, }},
        %{id: 1033, name: "Bow 3", value: 3, type: :weapon, specifically: %{kind: :weapon_bow, atk: 5, range: 5, }},
        %{id: 1034, name: "Bow 4", value: 4, type: :weapon, specifically: %{kind: :weapon_bow, atk: 7, range: 6, }},
        %{id: 1035, name: "Bow 5", value: 5, type: :weapon, specifically: %{kind: :weapon_bow, atk: 9, range: 7, }},
        %{id: 1041, name: "Fire Staff 1", value: 1, type: :weapon, specifically: %{kind: :weapon_staff, atk: 4,  range: 1, elem: :elem_fire }},
        %{id: 1042, name: "Fire Staff 2", value: 2, type: :weapon, specifically: %{kind: :weapon_staff, atk: 5,  range: 1, elem: :elem_fire }},
        %{id: 1043, name: "Fire Staff 3", value: 3, type: :weapon, specifically: %{kind: :weapon_staff, atk: 6,  range: 3, elem: :elem_fire }},
        %{id: 1044, name: "Fire Staff 4", value: 4, type: :weapon, specifically: %{kind: :weapon_staff, atk: 8,  range: 4, elem: :elem_fire }},
        %{id: 1045, name: "Fire Staff 5", value: 5, type: :weapon, specifically: %{kind: :weapon_staff, atk: 12, range: 4, elem: :elem_fire }},
        %{id: 1051, name: "Ice Staff 1", value: 1, type: :weapon, specifically: %{kind: :weapon_staff, atk: 2,  range: 1, elem: :elem_ice }},
        %{id: 1052, name: "Ice Staff 2", value: 2, type: :weapon, specifically: %{kind: :weapon_staff, atk: 6,  range: 1, elem: :elem_ice }},
        %{id: 1053, name: "Ice Staff 3", value: 3, type: :weapon, specifically: %{kind: :weapon_staff, atk: 7,  range: 2, elem: :elem_ice }},
        %{id: 1054, name: "Ice Staff 4", value: 4, type: :weapon, specifically: %{kind: :weapon_staff, atk: 9,  range: 3, elem: :elem_ice }},
        %{id: 1055, name: "Ice Staff 5", value: 5, type: :weapon, specifically: %{kind: :weapon_staff, atk: 13, range: 4, elem: :elem_ice }},
        %{id: 1061, name: "Lightning Staff 1", value: 1, type: :weapon, specifically: %{kind: :weapon_staff, atk: 3,  range: 1, elem: :elem_lightning }},
        %{id: 1062, name: "Lightning Staff 2", value: 2, type: :weapon, specifically: %{kind: :weapon_staff, atk: 4,  range: 2, elem: :elem_lightning }},
        %{id: 1063, name: "Lightning Staff 3", value: 3, type: :weapon, specifically: %{kind: :weapon_staff, atk: 8,  range: 2, elem: :elem_lightning }},
        %{id: 1064, name: "Lightning Staff 4", value: 4, type: :weapon, specifically: %{kind: :weapon_staff, atk: 10,  range: 3, elem: :elem_lightning }},
        %{id: 1065, name: "Lightning Staff 5", value: 5, type: :weapon, specifically: %{kind: :weapon_staff, atk: 11, range: 5, elem: :elem_lightning }},
        %{id: 1071, name: "Healing Staff 1", value: 1, type: :weapon, specifically: %{kind: :weapon_staff, heal: 3, atk: 1, range: 1, elem: :elem_healing }},
        %{id: 1072, name: "Healing Staff 2", value: 2, type: :weapon, specifically: %{kind: :weapon_staff, heal: 5, atk: 2, range: 1, elem: :elem_healing }},
        %{id: 1073, name: "Healing Staff 3", value: 3, type: :weapon, specifically: %{kind: :weapon_staff, heal: 7, atk: 3, range: 2, elem: :elem_healing }},
        %{id: 1074, name: "Healing Staff 4", value: 4, type: :weapon, specifically: %{kind: :weapon_staff, heal: 9, atk: 4, range: 2, elem: :elem_healing }},
        %{id: 1075, name: "Healing Staff 5", value: 5, type: :weapon, specifically: %{kind: :weapon_staff, heal: 6, atk: 5, range: 3, area: 2, elem: :elem_healing }},

        # Armor
        %{id: 2001, name: "Robes 1", value: 1, type: :armor, specifically: %{kind: :armor_robes, def: 1 }},
        %{id: 2002, name: "Robes 2", value: 2, type: :armor, specifically: %{kind: :armor_robes, def: 2 }},
        %{id: 2003, name: "Robes 3", value: 3, type: :armor, specifically: %{kind: :armor_robes, def: 3 }},
        %{id: 2004, name: "Robes 4", value: 4, type: :armor, specifically: %{kind: :armor_robes, def: 4 }},
        %{id: 2005, name: "Robes 5", value: 5, type: :armor, specifically: %{kind: :armor_robes, def: 5 }},
        %{id: 2011, name: "Light Armor 1", value: 1, type: :armor, specifically: %{kind: :armor_light, def: 2 }},
        %{id: 2012, name: "Light Armor 2", value: 2, type: :armor, specifically: %{kind: :armor_light, def: 3 }},
        %{id: 2013, name: "Light Armor 3", value: 3, type: :armor, specifically: %{kind: :armor_light, def: 5 }},
        %{id: 2014, name: "Light Armor 4", value: 4, type: :armor, specifically: %{kind: :armor_light, def: 6 }},
        %{id: 2015, name: "Light Armor 5", value: 5, type: :armor, specifically: %{kind: :armor_light, def: 8 }},
        %{id: 2021, name: "Heavy Armor 1", value: 1, type: :armor, specifically: %{kind: :armor_heavy, def: 3 }},
        %{id: 2022, name: "Heavy Armor 2", value: 2, type: :armor, specifically: %{kind: :armor_heavy, def: 5 }},
        %{id: 2023, name: "Heavy Armor 3", value: 3, type: :armor, specifically: %{kind: :armor_heavy, def: 6 }},
        %{id: 2024, name: "Heavy Armor 4", value: 4, type: :armor, specifically: %{kind: :armor_heavy, def: 8 }},
        %{id: 2025, name: "Heavy Armor 5", value: 5, type: :armor, specifically: %{kind: :armor_heavy, def: 10 }},

        # Shields
        %{id: 3001, name: "Shield 1", value: 1, type: :bonus, specifically: %{kind: :shield, def: 2 }},
        %{id: 3002, name: "Shield 2", value: 2, type: :bonus, specifically: %{kind: :shield, def: 4 }},
        %{id: 3003, name: "Shield 3", value: 3, type: :bonus, specifically: %{kind: :shield, def: 6 }},
    ] end
end
