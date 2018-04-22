defmodule Shining.Engine.HexTile do
  alias Shining.Engine.HexTile
  defstruct [:tile, :coordinates, :decor, :borders]
  # TODO: strictly type tile. Eg. :grass, :dirt
  @type t :: %HexTile{
    tile: atom,
    coordinates: {integer(), integer(), integer()},
    decor: number,
    borders: number
  }
end
