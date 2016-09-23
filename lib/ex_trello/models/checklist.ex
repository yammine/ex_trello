defmodule ExTrello.Model.Checklist do
  defstruct id: nil, name: nil, check_items: nil, cards: nil, id_card: nil, id_board: nil

  @type t :: %__MODULE__{}
end
