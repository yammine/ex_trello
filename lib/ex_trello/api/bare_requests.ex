defmodule ExTrello.API.BareRequests do
  @moduledoc """
  This module exists to provide ExTrello users with an interface to easily make requests to Trello that have not yet
  been implemented in the wrapper.

  TODO: Add some 'best guess' parsing of responses to provide anyone who uses these functions the same structured responses
  as the other implemented functions.

  Still not 100% on this, may just leave bare responses exposed for people who don't find value in the named structs.
  """

  import ExTrello.API.Base

  defapicall get(path, params \\ []) when is_list(params) do
    request(:get, path, params)
  end

  defapicall post(path, params \\ []) when is_list(params) do
    request(:post, path, params)
  end

  defapicall put(path, params \\ []) when is_list(params) do
    request(:put, path, params)
  end

  defapicall delete(path, params \\ []) when is_list(params) do
    request(:delete, path, params)
  end
end
