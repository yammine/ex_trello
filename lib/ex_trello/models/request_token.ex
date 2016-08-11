defmodule ExTrello.Model.RequestToken do
  @moduledoc """
  A Struct that represents all possible fields a `request_token` resource from Trello can be returned with.
  """
  defstruct oauth_token: nil, oauth_token_secret: nil, oauth_callback_confirmed: nil

  @type t :: %__MODULE__{}
end
