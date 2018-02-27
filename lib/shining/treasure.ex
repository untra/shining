defmodule Shining.Treasure do
    # vegetation_items :: items
    # beast 1 - rabbit
    # beast 2 - turkey
    # beast 3 - wisp
    # beast 4 - snarevine
    # beast 10XX - mercenary level X
    # chests :c, :u, :r, :m
    # [:c], [:c, :c], [:c, :u], [:c, :c, :u], [:c, :u, :u], [:c, :u, :r], [:c, :c, :u, :r], [:c, :u, :u, :r], [:c, :u, :r, :r], [:c, :u, :r, :m ], [:c, :c, :u, :r, :m ], [:c, :u, :u, :r, :m ], [:c, :u, :r, :r, :m ], [:u, :u, :r, :r, :m], [:u, :r, :r, :m, :m ]

    # common - items
    # uncommon - leveled + 1 items & weapons + armor
    # rare - leveled + 1 weapons and armor, bonus items
    # mythic - leveled bonus items, 2 leveled +1 items

    def c_treasure() do
    # TODO: subdivide one more time
    [
        [31]
        [31, 31, 41, 41, 51],
        [31, 41, 41, 41, 51, 42],
        [32, 41, 42, 51],
        [71, 32, 32, 41, 42, 51, 52],
        [71, 72, 32, 42, 42, 42, 52, 43],
        [71, 72, 33, 42, 43, 52, 43],
        #6
        [72, 33, 33, 43, 43, 53],
        #8
        [72, 73, 33, 43, 43, 43, 53, 44],
        #10
        [73, 34, 34, 44, 44, 54],
        #12
        [73, 74, 34, 44, 44, 44, 54]
        #14
    ]
    end

    def u_treasure() do
    [
        [42],
        [42],
        [42],
        [2001, 2011, 2021],
    ]
    end

    def roll_chests(0), do: :c 
    def roll_chests(value) when is_integer(value) do
        chests = [[:c], [:c, :c], [:c, :u], [:c, :c, :u], [:c, :u, :u], [:c, :u, :r], [:c, :c, :u, :r], [:c, :u, :u, :r], [:c, :u, :r, :r], [:c, :u, :r, :m ], [:c, :c, :u, :r, :m ], [:c, :u, :u, :r, :m ], [:c, :u, :r, :r, :m ], [:u, :u, :r, :r, :m], [:u, :r, :r, :m, :m ]]
    end


    def get(id) when is_integer(id), do: all() |> Enum.find(fn(x) -> Map.get(x, :id) == id end)
    def get(id, alt) when is_integer(id), do: get(id) || alt
    def all() do
        [
            # 0 level, dead center
            %{id: 0, value: 0,vegetation_items: [
                # two each herbs, flowers and apples
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                # one chest, randomly placed
                [:c]
            ], enemies: [
                # rabbit, turkey, mercenary level 0
                [1, 2, 1000]
            ]  }},
            # 1 level, first ring
            %{id: 1, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                # 50% has one chest
                [], [:c]
            ], enemies: [
                [1, 2, 1000]
            ]  }},
            %{id: 2, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                # 25% has a chest, 25% has two chests
                {[], 2}, [:c], [:c, :c]
            ], enemies: [
                [1, 2, 1000]
            ]  }},
            %{id: 3, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                # 1/6 chance each 
                {[], 3}, [:c], [:c, :c], [:c, :u]
            ],, enemies: [
                [1, 2, 1000]
            ]  }},
            %{id: 4, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                # 1/8 chance each above and a 2-chest and uncommon 
                {[], 4}, [:c], [:c, :c], [:c, :u], [:c, :c :u]
            ],, enemies: [
                [1, 2, 1000]
            ]  }},
            
        ]
    end
end