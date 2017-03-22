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
    {authorization_header, request_params} = OAuther.header(signed_params)

    case method do
      :get ->
        HTTPoison.get(url <> "?#{URI.encode_query(request_params)}", [authorization_header])
      :file ->
        HTTPoison.post(url, {:multipart, prep_file_upload(request_params)}, [authorization_header])
      _ ->
        # https://hexdocs.pm/httpoison/HTTPoison.html#request/5
        HTTPoison.request(
          method,
          url,
          {:form, request_params},
          [authorization_header]
        )
    end |> elem(1)
  end

  defp prep_file_upload(params) do
    params |> Enum.map(fn
      {"file", value} ->
        {:file, value}
      any ->
        any
    end)
  end

  defp stringify_params(params) when is_list(params) do
    Enum.map(params, fn({k, v}) -> {to_string(k), v} end)
  end
end
