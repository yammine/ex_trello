defmodule ExTrello.Model.RequestToken do
  defstruct oauth_token: nil, oauth_token_secret: nil, oauth_callback_confirmed: nil

  @type t :: %__MODULE__{}
end
