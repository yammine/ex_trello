defmodule ExTrello.OAuth do
  @moduledoc """
  Provide a wrapper for :oauth request methods.
  """
  @doc """
  Send a signed request

  ## Options

      * `stream_to` Specify a process to stream the response to when performing async requests
      * `follow_redirects` Specify whether redirects should be followed.
  """
  def request(method, url, params, credentials, opts \\ []) do
    signed_params = OAuther.sign(to_string(method), url, stringify_params(params), credentials)
    {header, _request_params} = OAuther.header(signed_params)

    content_type = if opts[:content_type], do: opts[:content_type], else: "application/x-www-form-urlencoded"

    HTTPotion.request(method, url <> "?#{URI.encode_query(signed_params)}", header: [{"Content-Type", content_type}, header])
  end

  defp stringify_params(params) when is_list(params) do
    Enum.map(params, fn({k, v}) ->  {to_string(k), v} end)
  end
  defp stringify_params(params) when is_binary(params), do: params # Likely JSON or plaintext
end
