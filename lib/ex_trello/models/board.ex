defmodule ExTrello.Model.Board do
  @moduledoc """
  A Struct that represents all possible fields a `board` resource from Trello can be returned with.
  """
  defstruct id: nil, closed: nil, date_last_activity: nil, date_last_view: nil, desc: nil, desc_data: nil,
            id_organization: nil, invitations: [], label_names: %{}, memberships: [], name: nil, pinned: nil,
            prefs: %{}, short_link: nil, short_url: nil, starred: nil, subscribed: nil, url: nil, cards: nil,
            actions: nil, lists: nil, members: nil, power_ups: nil

  @type t :: %__MODULE__{}
end
