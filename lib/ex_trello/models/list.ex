defmodule ExTrello.Model.List do
  @moduledoc """
  A Struct that represents all possible fields a `list` resource from Trello can be returned with.
  """
  defstruct id: nil, name: nil, closed: nil, subscribed: nil, pos: nil, id_board: nil, board: nil, cards: nil

  @type t :: %__MODULE__{}
end
