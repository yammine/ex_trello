defmodule ExTrello.Model.Member do
  @moduledoc """
  A Struct that represents all possible fields a `member` resource from Trello can be returned with.
  """
  defstruct id: nil, username: nil, full_name: nil, url: nil, organizations: nil, boards: nil, actions: nil,
            saved_searches: nil, notifications: nil, tokens: nil, paid_account: nil, board_backgrounds: nil,
            custom_board_backgrounds: nil, custom_stickers: nil, custom_emoji: nil, avatar_hash: nil,
            avatar_source: nil, bio: nil, bio_data: nil, confirmed: nil, email: nil, gravatar_hash: nil,
            initials: nil, id_boards: nil, id_boards_pinned: nil, id_organizations: nil, id_prem_orgs_admin: nil,
            login_types: nil, member_type: nil, one_time_messages_dismissed: nil, prefs: nil, premium_features: nil,
            products: nil, status: nil, trophies: nil, uploaded_avatar_hash: nil, board_stars: nil, cards: nil

  @type t :: %__MODULE__{}
end
