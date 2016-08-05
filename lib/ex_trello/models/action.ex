defmodule ExTrello.Model.Action do
  defstruct id: nil, data: nil, display: nil, entities: nil, date: nil, id_member_creator: nil, type: nil, member: nil,
            member_creator: nil

  @type t :: %__MODULE__{}
end
