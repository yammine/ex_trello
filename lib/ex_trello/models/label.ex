defmodule ExTrello.Model.Label do
  @moduledoc """
  A Struct that represents all possible fields a `label` from Trello can be returned with
  """
  defstruct id: nil, color: nil, idBoard: nil, name: nil, uses: nil

  @type t :: %__MODULE__{}
end
