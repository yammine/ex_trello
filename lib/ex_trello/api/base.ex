defmodule ExTrello.API.Base do
  @moduledoc """
  Provides basic and common functionalities for Trello API.
  """

  alias ExTrello.Utils

  @doc """
  Send request to the api.trello.com server.
  """
  def request(method, path, params \\ []) do
    do_request(method, request_url(path), params)
  end

  defp do_request(method, url, params) do
    oauth = ExTrello.Config.get_tuples |> verify_params
    consumer = {oauth[:app_key], oauth[:app_secret], :hmac_sha1}
    token = oauth[:access_token]
    secret = oauth[:access_token_secret]
    case ExTrello.OAuth.request(method, url, params, consumer, token, secret) do
      {:error, reason} -> raise(ExTrello.ConnectionError, reason: reason)
      r -> r |> parse_result
    end
  end

  def verify_params([]) do
    raise %ExTrello.Error{
      message: "OAuth parameters are not set. Use ExTrello.configure function to set parameters in advance." }
  end

  def verify_params(params), do: params

  def request_url(path) do
    "https://api.trello.com/1/#{path}" |> to_char_list
  end

  def parse_result(result) do
    {:ok, {{_http_version, status_code, _status_text}, _header, body}} = result

    case status_code do
      code when code >= 200 and code < 300 ->
        ExTrello.JSON.decode!(body)
        |> Utils.snake_case_keys
      _ ->
        raise %ExTrello.Error{code: status_code, message: to_string(body)}
    end
  end
end
