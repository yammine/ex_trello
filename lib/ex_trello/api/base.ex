defmodule ExTrello.API.Base do
  @moduledoc """
  Provides basic and common functionalities for Twitter API.
  """

  @doc """
  Send request to the api.trello.com server.
  """
  def request(method, path, params \\ []) do
    do_request(method, request_url(path), params)
  end

  defp do_request(method, url, params) do
    oauth = ExTrello.Config.get_tuples |> verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
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
    {:ok, {_response, header, body}} = result
    verify_response(ExTrello.JSON.decode!(body), header)
  end

  defp verify_response(body, header) do
    if is_list(body) do
      body
    else
      case Map.get(body, :errors, nil) || Map.get(body, :error, nil) do
        nil ->
          body
        errors when is_list(errors) ->
          parse_error(List.first(errors), header)
        error ->
          raise(ExTrello.Error, message: inspect error)
      end
    end
  end

  defp parse_error(error, header) do
    %{:code => code, :message => message} = error
    raise ExTrello.Error, code: code, message: message
  end
end
