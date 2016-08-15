defmodule ExTrello.API.Auth do
  @moduledoc """
  Provides Authorization and Authentication API interfaces.
  """
  import ExTrello.API.Base
  alias ExTrello.{Config, OAuth, Parser, Utils}

  def request_token(redirect_url \\ nil) do
    config = Config.get |> verify_params

    credentials = OAuther.credentials([consumer_key: config[:consumer_key], consumer_secret: config[:consumer_secret]])
    params = if redirect_url, do: [{"oauth_callback", redirect_url}], else: []

    case OAuth.request(:get, request_url("OAuthGetRequestToken"), params, credentials) do
      %HTTPotion.Response{body: body} ->
        URI.decode_query(body)
        |> Utils.snake_case_keys
        |> Parser.parse_request_token
      %HTTPotion.ErrorResponse{message: message} ->
        raise(ExTrello.ConnectionError, reason: message)
    end
  end

  def authorize_url(oauth_token), do: authorize_url(oauth_token, [])
  def authorize_url(oauth_token, options) when is_list(options), do: authorize_url(oauth_token, Enum.into(options, %{}))
  def authorize_url(oauth_token, options) when is_map(options) do
    args = Map.merge(%{oauth_token: oauth_token}, options)

    {:ok, request_url("OAuthAuthorizeToken?" <> URI.encode_query(args))}
  end

  def access_token(verifier, request_token, request_token_secret) do
    config = Config.get |> verify_params

    consumer = [consumer_key: config[:consumer_key], consumer_secret: config[:consumer_secret]]
    credentials = [{:token, request_token}, {:token_secret, request_token_secret} | consumer] |> OAuther.credentials

    case OAuth.request(:get, request_url("OAuthGetAccessToken"), [oauth_verifier: verifier], credentials) do
      %HTTPotion.Response{body: body, status_code: 200} ->
        access_token = URI.decode_query(body)
        |> Utils.snake_case_keys
        |> Parser.parse_access_token
        {:ok, access_token}
      %HTTPotion.Response{body: body, status_code: code} ->
        raise(ExTrello.Error, code: code, message: body)
      %HTTPotion.ErrorResponse{message: message} ->
        raise(ExTrello.ConnectionError, reason: message)
    end
  end
end
