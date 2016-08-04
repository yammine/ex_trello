defmodule ExTrello.Parser do
  @moduledoc """
  Provides parser logic for API results.
  """
  @nested_resources ~w(board boards card cards list lists)a

  @doc """
  Check the possible nested resources for any given object.
  """
  def check_nested_resources(object) do
    do_check(object, @nested_resources)
  end
  defp do_check(object, [resource | rest]) do
    object
    |> preprocess(resource)
    |> do_check(rest)
  end
  defp do_check(object, []), do: object

  # TODO: Maybe look into writing a macro to define these functions from the `@nested_resources` word list
  defp preprocess(%{board: board} = object, :board),    do: Map.put(object, :board, board |> parse_board)
  defp preprocess(%{boards: boards} = object, :boards), do: Map.put(object, :boards, Enum.map(boards, &parse_board/1))
  defp preprocess(%{card: card} = object, :card),       do: Map.put(object, :card, card |> parse_card)
  defp preprocess(%{cards: cards} = object, :cards),    do: Map.put(object, :cards, Enum.map(cards, &parse_card/1))
  defp preprocess(%{list: list} = object, :list),       do: Map.put(object, :list, list |> parse_list)
  defp preprocess(%{lists: lists} = object, :lists),    do: Map.put(object, :lists, Enum.map(lists, &parse_list/1))
  defp preprocess(object, _), do: object

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_string(k), to_string(v)} end)
  end

  @doc """
  Parse board record returned from API response json.
  """
  def parse_board(object) do
    object
    |> check_nested_resources
    |> (&(struct(ExTrello.Model.Board, &1))).()
  end

  @doc """
  Parse list record returned from API response json.
  """
  def parse_list(object) do
    object
    |> check_nested_resources
    |> (&(struct(ExTrello.Model.List, &1))).()
  end

  @doc """
  Parse card record returned from API response json.
  """
  def parse_card(object) do
    object
    |> check_nested_resources
    |> (&(struct(ExTrello.Model.Card, &1))).()
  end

  @doc """
  Parse access_token response
  """
  def parse_access_token(object) do
    object
    |> (&(struct(ExTrello.Model.AccessToken, &1))).()
  end

  @doc """
  Parse request_token response
  """
  def parse_request_token(object) do
    object
    |> (&(struct(ExTrello.Model.RequestToken, &1))).()
  end
end
