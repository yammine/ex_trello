defmodule ExTrello.Parser do
  @moduledoc """
  Provides parser logic for API results.
  """

  @doc """
  Parse access_token response
  """
  def parse_access_token(object) do
    struct(ExTrello.Model.AccessToken, object)
  end

  @doc """
  Parse request_token response
  """
  def parse_request_token(object) do
    struct(ExTrello.Model.RequestToken, object)
  end
end
