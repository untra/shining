defmodule Shining.Engine.Game do
  alias Shining.Engine.{HexCoordinates, Game}

  defstruct stage: :initial,
            board: HexCoordinates.gameboard(),
            players: [],
            characters: []
            
end