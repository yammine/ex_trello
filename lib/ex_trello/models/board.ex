defmodule ExTrello.Model.Board do
  defstruct id: nil, closed: nil, date_last_activity: nil, date_last_view: nil, desc: nil, desc_data: nil,
            id_organization: nil, invitations: [], label_names: %{}, memberships: [], name: nil, pinned: nil,
            prefs: %{}, short_link: nil, short_url: nil, starred: nil, subscribed: nil, url: nil

  @type t :: %__MODULE__{}
end
