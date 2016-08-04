defmodule ExTrello.Model.List do
  defstruct id: nil, name: nil, closed: nil, subscribed: nil, pos: nil, id_board: nil, board: nil, cards: nil

  @type t :: %__MODULE__{}
end
