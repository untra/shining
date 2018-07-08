defmodule Shining.Engine.HexCoordinates do
  @type hex_direction :: :nwest | :neast | :west | :east | :swest | :seast
  @type hex_coordinate :: {integer, integer, integer}

  @center {0,0,0}

  @spec valid?(hex_coordinate) :: boolean
  def valid?({x,y,z}) when x + y + z == 0, do: true
  def valid?(_), do: false
  
  

  @spec within_boundaries?(hex_coordinate, non_neg_integer) :: boolean
  def within_boundaries?({x,y,z}, b) when abs(x) <= b or abs(y) <= b or abs(z) <= b, do: false
  def within_boundaries?(_, _), do: true

  @spec boundary_overflow(hex_coordinate, non_neg_integer) :: hex_direction | :none
  def boundary_overflow({x,y,z}, b) do
      cond do
          abs(x) > b and x > 0 -> :de
          abs(x) > b and x < 0 -> :dw
          abs(y) > b and y > 0 -> :nw
          abs(y) > b and y < 0 -> :se
          abs(z) > b and z > 0 -> :sw
          abs(z) > b and z < 0 -> :ne
          true -> :none
      end
  end

  @spec correct(hex_coordinate, non_neg_integer) :: boolean
  def correct({x,y,z}, b) do
      cond do
          abs(x) > b and x > 0 -> correct({rem(x,b) - b - 1, y, z}, b)
          abs(x) > b and x < 0 -> correct({rem(x,b) + b + 1, y, z}, b)
          abs(y) > b and y > 0 -> correct({x, rem(y,b) - b - 1, z}, b)
          abs(y) > b and y < 0 -> correct({x, rem(y,b) + b + 1, z}, b)
          abs(z) > b and z > 0 -> correct({x, y, rem(z,b) - b - 1}, b)
          abs(z) > b and z < 0 -> correct({x, y, rem(z,b) + b + 1}, b)
          true -> {x, y, z}
      end
  end

  @spec area(hex_coordinate, non_neg_integer) :: list(hex_coordinate)
  def area({x0, y0, z0}, b) do
      for x <- -b .. b,
          y <- -b .. b,
          z <- -b .. b,
          valid?({x, y, z}) do
          {x + x0, y + y0, z + z0}
      end
  end

  def rotR({x,y,z}), do: {-z,-x,-y}
  def rotL({x,y,z}), do: {-y,-z,-x}

  # the cyclegroup is the six rotations
  # of the given coordinates around the center
  def cycleGroup({x,y,z}) do
    [{x,y,z},
    {-z,-x,-y},
    {-y,-z,-x},
    {y,z, x},
    {z,x,y},
    {-x, -y, -z}]
  end

  def reachable([_|visited], 0), do: visited
  def reachable([start|visited], movement) when movement > 0 do
    neighbors(start)
    # |> Enum.filter() for passable TODO
    |> Enum.map(fn (neighbor) -> MapSet.put(visited, reachable([neighbor, start|visited], movement-1)) end)
  end

  def mirrorCenters(n) when n > 0, do: cycleGroup({2 * n + 1, -n, -n-1})

  def moveLegal?(moves) when is_list(moves) do
    moves
    |> pairs()
    |> Enum.map(fn ([a,b]) -> stepLegal?(a,b) end)
  end

  def stepLegal?({x0,y0,z0}, {x1,y1,z1}) do
    neighbors({x0,y0,z0})
    |> Enum.member?({x1,y1,z1})
  end

    # TODO: fix this, write tests
  def pairs(steps), do: pairsBuilder(steps, 0)

  def pairsBuilder([], r), do: r
  def pairsBuilder([_], r), do: r
  def pairsBuilder([a, b|n], r), do: [[a, b] | [b | n]]

  def neighbors({x,y,z}) do
    [{x,y+1,z-1}, {x-1,y,z+1},{x+1,y-1,z},{x,y-1,z+1},{x-1,y+1,z},{x+1,y,z-1}]
  end

  @spec distance(hex_coordinate, hex_coordinate) :: non_neg_integer
  def distance({x0, y0, z0}, {x1, y1, z1}) do
      [abs(x0-x1), abs(y0-y1), abs(z0-z1)]
      |> Enum.max()
  end

  def gameboard(), do: area(@center, 3)


end
