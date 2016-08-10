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
    credentials = ExTrello.Config.get |> verify_params |> OAuther.credentials

    case ExTrello.OAuth.request(method, url, params, credentials) do
      %HTTPotion.ErrorResponse{message: message} -> raise(ExTrello.ConnectionError, reason: message)
      r -> r |> parse_result
    end
  end

  def verify_params([]) do
    raise %ExTrello.Error{
      message: "OAuth parameters are not set. Use ExTrello.configure function to set parameters in advance." }
  end

  def verify_params(params), do: params

  def request_url(path) do
    "https://api.trello.com/1/#{path}"
  end

  def parse_result(result) do
    case result do
      %HTTPotion.Response{body: body, status_code: code} when code >= 200 and code < 300 ->
        ExTrello.JSON.decode!(body)
        |> Utils.snake_case_keys
      %HTTPotion.Response{body: body, status_code: code} ->
        raise %ExTrello.Error{code: code, message: body}
    end
  end
end
