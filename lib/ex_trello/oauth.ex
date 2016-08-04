defmodule ExTrello.OAuth do
  @moduledoc """
  Provide a wrapper for :oauth request methods.
  """

  @doc """
  Send request with get method.
  """
  def request(:get, url, params, consumer, access_token, access_token_secret) do
    :oauth.get(url, params, consumer, access_token, access_token_secret, [])
  end

  @doc """
  Send request with post method.
  """
  def request(:post, url, params, consumer, access_token, access_token_secret) do
    :oauth.post(url, params, consumer, access_token, access_token_secret, [])
  end

  @doc """
  Send request with put method.
  """
  def request(:put, url, params, consumer, access_token, access_token_secret) do
    :oauth.put(url, params, {'application/x-www-form-urlencoded', []}, consumer, access_token, access_token_secret)
  end

  @doc """
  Send async request with get method.
  """
  def request_async(:get, url, params, consumer, access_token, access_token_secret) do
    :oauth.get(url, params, consumer, access_token, access_token_secret, stream_option)
  end

  @doc """
  Send async request with post method.
  """
  def request_async(:post, url, params, consumer, access_token, access_token_secret) do
    :oauth.post(url, params, consumer, access_token, access_token_secret, stream_option)
  end

  @doc """
  Send async request with put method.
  """
  def request_async(:put, url, params, consumer, access_token, access_token_secret) do
    :oauth.put(url, params, {'application/x-www-form-urlencoded', []}, consumer, access_token, access_token_secret, stream_option)
  end

  defp stream_option do
    [{:sync, false}, {:stream, :self}]
  end
end
