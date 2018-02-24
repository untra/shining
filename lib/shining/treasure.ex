defmodule Shining.Treasure do
    # vegetation_items :: items
    # beast 1 - rabbit
    # beast 2 - turkey
    # beast 3 - wisp
    # beast 4 - snarevine
    # beast 10XX - mercenary level X
    # chests :c, :u, :r, :m
    # [:c], [:c, :c], [:c, :u], [:c, :c, :u], [:c, :u, :u], [:c, :u, :r], [:c, :c, :u, :r], [:c, :u, :u, :r], [:c, :u, :r, :r], [:c, :u, :r, :m ], [:c, :c, :u, :r, :m ], [:c, :u, :u, :r, :m ], [:c, :u, :r, :r, :m ], [:u, :u, :r, :r, :m], [:u, :r, :r, :m, :m ]

    def get(id) when is_integer(id), do: all() |> Enum.find(fn(x) -> Map.get(x, :id) == id end)
    def get(id, alt) when is_integer(id), do: get(id) || alt
    def all() do
        [
            # 0 level, dead center
            %{id: 0, value: 0,vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                [:c]
            ], enemies: [
                [1, 2, 1000]
            ]  }},
            # 1 level, first ring
            %{id: 1, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                [], [:c]
            ], enemies: [
                [1, 2, 1000]
            ]  }},
            %{id: 2, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                {[], 2}, [:c], [:c, :c]
            ], enemies: [
                [1, 2, 1000]
            ]  }},
            %{id: 3, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                {[], 3}, [:c], [:c, :c], [:c, :u]
            ],, enemies: [
                [1, 2, 1000]
            ]  }},
            %{id: 4, value: 0, vegetation_items: [
                [1, 1, 11, 11, 61, 61]
            ], chests: [
                {[], 4}, [:c], [:c, :c], [:c, :u], [:c, :c :u]
            ],, enemies: [
                [1, 2, 1000]
            ]  }},
            
        ]
    end
end