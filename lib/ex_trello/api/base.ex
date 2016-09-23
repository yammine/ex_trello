defmodule ExTrello.API.Base do
  @moduledoc """
  Provides basic and common functionalities for Trello API.
  """

  alias ExTrello.Utils

  @doc """
  Define a function with this `defapicall` macro instead of `def` to catch errors and decorate our responses.
  """
  defmacro defapicall(call, expression) do
    quote do
      def unquote(call) do # Defines a function with the definition supplied
        try do
          {:ok, unquote(expression[:do])} # execute anything in our `do` block
        catch
          %ExTrello.Error{} = error -> # self-explainatory
            {:error, error}
          %ExTrello.ConnectionError{} = error ->
            {:connection_error, error}
        end
      end
    end
  end

  @doc """
  Send request to the api.trello.com server.
  """
  def request(method, path, params \\ []) do
    do_request(method, request_url(path), params)
  end

  defp do_request(method, url, params) do
    credentials = ExTrello.Config.get |> verify_params |> OAuther.credentials

    case ExTrello.OAuth.request(method, url, params, credentials) do
      %HTTPotion.Response{body: body, status_code: code} when code >= 200 and code < 300 ->
        Poison.decode!(body)
        |> Utils.snake_case_keys

      %HTTPotion.Response{body: body, status_code: code} ->
        throw(%ExTrello.Error{code: code, message: body})

      %HTTPotion.ErrorResponse{message: message} ->
        throw(%ExTrello.ConnectionError{reason: message})
    end
  end

  def verify_params([]) do
    throw(%ExTrello.Error{message: "OAuth parameters are not set. Use ExTrello.configure function to set parameters in advance."})
  end

  def verify_params(params), do: params

  def request_url(path) do
    "https://api.trello.com/1/#{path}"
  end
end
