defmodule ExTrello.Model.AccessToken do
  defstruct oauth_token: nil, oauth_token_secret: nil

  @type t :: %__MODULE__{}
end
