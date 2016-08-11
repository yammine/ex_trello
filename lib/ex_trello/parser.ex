defmodule ExTrello.Parser do
  @moduledoc """
  Provides parser logic for API results.
  """
  @nested_resources ~w(board boards card cards list lists action actions organization organizations member members)a

  @doc """
  Check the possible nested resources for any given object. Should work on any arbitrarily nested objects.
  TODO: Test coverage
  """
  def check_nested_resources(object) when is_map(object) do
    arbitrarily_nested = Enum.reduce(object, %{}, fn
      {key, value}, acc when is_map(value) and not (key in @nested_resources) ->
        Map.put(acc, key, check_nested_resources(value))
      {key, value}, acc when is_list(value) and not (key in @nested_resources) ->
        Map.put(acc, key, Enum.map(value, &check_nested_resources/1))
      _, acc ->
        acc
    end)

    Map.merge(do_check(object, @nested_resources), arbitrarily_nested)
  end
  def check_nested_resources(not_a_map), do: not_a_map

  defp do_check(object, [resource | rest]) do
    object
    |> preprocess(resource)
    |> do_check(rest)
  end
  defp do_check(object, []), do: object

  # TODO: Maybe look into writing a macro to define these functions from the `@nested_resources` word list
  defp preprocess(%{board: board} = object, :board),       do: Map.put(object, :board, board |> parse_board)
  defp preprocess(%{boards: boards} = object, :boards),    do: Map.put(object, :boards, Enum.map(boards, &parse_board/1))
  defp preprocess(%{card: card} = object, :card),          do: Map.put(object, :card, card |> parse_card)
  defp preprocess(%{cards: cards} = object, :cards),       do: Map.put(object, :cards, Enum.map(cards, &parse_card/1))
  defp preprocess(%{list: list} = object, :list),          do: Map.put(object, :list, list |> parse_list)
  defp preprocess(%{lists: lists} = object, :lists),       do: Map.put(object, :lists, Enum.map(lists, &parse_list/1))
  defp preprocess(%{action: action} = object, :action),    do: Map.put(object, :action, action |> parse_action)
  defp preprocess(%{actions: actions} = object, :actions), do: Map.put(object, :actions, Enum.map(actions, &parse_action/1))
  defp preprocess(%{member: member} = object, :member),    do: Map.put(object, :member, member |> parse_member)
  defp preprocess(%{members: members} = object, :members), do: Map.put(object, :members, Enum.map(members, &parse_member/1))
  defp preprocess(%{organization: organization} = object, :organization),    do: Map.put(object, :organization, organization |> parse_organization)
  defp preprocess(%{organizations: organizations} = object, :organizations), do: Map.put(object, :organizations, Enum.map(organizations, &parse_organization/1))
  defp preprocess(object, _), do: object

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
  Parse action record returned from API response json.
  """
  def parse_action(object) do
    object
    |> check_nested_resources
    |> (&(struct(ExTrello.Model.Action, &1))).()
  end

  @doc """
  Parse member record returned from API response json.
  """
  def parse_member(object) do
    object
    |> check_nested_resources
    |> (&(struct(ExTrello.Model.Member, &1))).()
  end

  @doc """
  Parse organization record returned from API response json.
  """
  def parse_organization(object) do
    object
    |> check_nested_resources
    |> (&(struct(ExTrello.Model.Organization, &1))).()
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
