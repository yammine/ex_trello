defmodule ExTrello.API.Auth do
  @moduledoc """
  Provides Authorization and Authentication API interfaces.
  """
  import ExTrello.API.Base
  alias ExTrello.{Config, OAuth, Parser}

  def request_token(redirect_url \\ nil) do
    oauth = Config.get_tuples |> verify_params
    params = if redirect_url, do: [{"return_url", redirect_url}], else: []
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    {:ok, {{_, 200, _}, _headers, body}} = OAuth.request(:post, request_url("OAuthGetRequestToken"), params, consumer, [], [])

    URI.decode_query(to_string body)
    |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
    |> Parser.parse_request_token
  end

  def authorize_url(oauth_token, options \\ %{}) do
    args = Map.merge(%{oauth_token: oauth_token}, options)

    {:ok, request_url("OAuthAuthorizeToken?" <> URI.encode_query(args)) |> to_string}
  end

  def access_token(verifier, request_token) do
    oauth = Config.get_tuples |> verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    case OAuth.request(:post, request_url("OAuthGetAccessToken"), [oauth_verifier: verifier], consumer, request_token, nil) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        access_token = URI.decode_query(to_string body)
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})
        |> Parser.parse_access_token
        {:ok, access_token}
      {:ok, {{_, code, _}, _, _}} ->
        {:error, code}
    end
  end
end
