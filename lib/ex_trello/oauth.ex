defmodule ExTrello.OAuth do
  @moduledoc """
  Provide a wrapper for :oauth request methods.
  """
  @doc """
  Send a signed request

  ## Options (NOTE: these don't do anything yet.)
    * `stream_to` Specify a process to stream the response to when performing async requests
    * `follow_redirects` Specify whether redirects should be followed.
  """
  def request(method, url, params, credentials, _opts \\ []) do
    signed_params = OAuther.sign(to_string(method), url, stringify_params(params), credentials)
    {header, request_params} = OAuther.header(signed_params)

    case method do
      :get ->
        HTTPotion.request(method, url <> "?#{URI.encode_query(request_params)}", headers: [header])
      _ ->
        HTTPotion.request(method, url, headers: [header, {"Content-Type", "application/x-www-form-urlencoded"}], body: URI.encode_query(request_params))
    end
  end

  defp stringify_params(params) when is_list(params) do
    Enum.map(params, fn({k, v}) ->  {to_string(k), v} end)
  end
end
