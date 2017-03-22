defmodule ExTrello.Config do
  def current_scope do
    if Process.get(:_ex_trello_oauth, nil), do: :process, else: :global
  end

  @doc """
  Get OAuth configuration values.
  """
  def get, do: get(current_scope())
  def get(:global) do
    Application.get_env(:ex_trello, :oauth, nil)
  end
  def get(:process), do: Process.get(:_ex_trello_oauth, nil)

  @doc """
  Set OAuth configuration values.
  """
  def set(value), do: set(current_scope(), value)
  def set(:global, value), do: Application.put_env(:ex_trello, :oauth, value)
  def set(:process, value) do
    Process.put(:_ex_trello_oauth, value)
    :ok
  end
end
