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
    {:ok, {_response, header, body}} = result

    case List.keyfind(header, 'content-type', 0) |> elem(1) do
      'application/json; charset=utf-8' ->
        verify_response(ExTrello.JSON.decode!(body), header)
        |> Utils.snake_case_keys
      'text/plain; charset=utf-8' ->
        raise(ExTrello.Error, code: 400, message: body)
    end
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
