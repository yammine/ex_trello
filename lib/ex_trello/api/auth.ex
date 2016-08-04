defmodule ExTrello.API.Auth do
  @moduledoc """
  Provides Authorization and Authentication API interfaces.
  """
  import ExTrello.API.Base
  alias ExTrello.{Config, OAuth, Parser}

  def request_token(redirect_url \\ nil) do
    oauth = Config.get_tuples |> verify_params
    params = if redirect_url, do: [{"oauth_callback", redirect_url}], else: []
    consumer = {oauth[:app_key], oauth[:app_secret], :hmac_sha1}

    case OAuth.request(:get, request_url("OAuthGetRequestToken"), params, consumer, [], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        URI.decode_query(to_string body)
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end) #TODO: get rid of the String.to_atom/1 and any expectation downstream.
        |> Enum.into(%{})
        |> Parser.parse_request_token
      {:error, reason} ->
        raise(ExTrello.ConnectionError, reason: reason)
    end
  end

  def authorize_url(oauth_token, options \\ %{}) do
    args = Map.merge(%{oauth_token: oauth_token}, options)

    {:ok, request_url("OAuthAuthorizeToken?" <> URI.encode_query(args)) |> to_string}
  end

  def access_token(verifier, request_token, request_token_secret) do
    oauth = Config.get_tuples |> verify_params
    consumer = {oauth[:app_key], oauth[:app_secret], :hmac_sha1}
    case OAuth.request(:get, request_url("OAuthGetAccessToken"), [oauth_verifier: verifier], consumer, request_token, request_token_secret) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        access_token = URI.decode_query(to_string body)
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end) #TODO: get rid of the String.to_atom/1 and any expectation downstream.
        |> Enum.into(%{})
        |> Parser.parse_access_token
        {:ok, access_token}
      {:ok, {{_, code, _}, _, body}} ->
        raise(ExTrello.Error, code: code, message: to_string(body))
      {:error, reason} ->
        raise(ExTrello.ConnectionError, reason: reason)
    end
  end
end
