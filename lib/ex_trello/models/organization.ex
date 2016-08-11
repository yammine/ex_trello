defmodule ExTrello.Model.Organization do
  @moduledoc """
  A Struct that represents all possible fields a `organization` resource from Trello can be returned with.
  """
  defstruct id: nil, billable_member_count: nil, desc: nil, desc_data: nil, display_name: nil, id_boards: nil,
            invitations: nil, invited: nil, logo_hash: nil, memberships: nil, name: nil, power_ups: nil, prefs: nil,
            premium_features: nil, products: nil, url: nil, website: nil, actions: nil, members: nil, boards: nil,
            paid_account: nil

  @type t :: %__MODULE__{}
end
