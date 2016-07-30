defmodule ExTrello.Parser do
  @moduledoc """
  Provides parser logic for API results.
  """

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_string(k), to_string(v)} end)
  end

  @doc """
  Parse board record returned from API response json.
  """
  def parse_board(object) do
    struct(ExTrello.Model.Board, object)
  end

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
