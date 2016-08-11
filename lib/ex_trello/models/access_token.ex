defmodule ExTrello.Model.AccessToken do
  @moduledoc """
  A Struct that represents all possible fields a `access_token` resource from Trello can be returned with.
  """
  defstruct oauth_token: nil, oauth_token_secret: nil

  @type t :: %__MODULE__{}
end
