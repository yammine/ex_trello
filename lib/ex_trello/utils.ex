defmodule ExTrello.Utils do
  @moduledoc """
  A collection of helpful utility functions.
  """
  @capitalized_letters ~w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

  @doc """
  Will parse over any JSON response from the Trello API & snake case any camelCased keys (also convert them to atoms)

  Example
      body = %{"dateLastActivity" => %{ potatoSkins: "asdf", somethingElse: %{ "heyThere" => "sup"}}, rootMap: "right here", someList: [%{keysInHere: "too"}, %{cantBelieve: %{thisIsHappening: "it is tho"}}]}
      ExTrello.Utils.snake_case_keys(body)

      %{date_last_activity: %{potato_skins: "asdf", something_else: %{hey_there: "sup"}}, root_map: "right here"}
  """
  def snake_case_keys(map) when is_map(map) do
    Enum.reduce(map, %{}, fn
      {key, value}, acc when is_map(value) ->
        Map.put(acc, Macro.underscore(key) |> attempt_atom_conversion, snake_case_keys(value))
      {key, value}, acc when is_list(value) ->
        Map.put(acc, Macro.underscore(key) |> attempt_atom_conversion, Enum.map(value, &snake_case_keys/1))
      {key, value}, acc ->
        Map.put(acc, Macro.underscore(key) |> attempt_atom_conversion, value)
    end)
  end
  def snake_case_keys(object) when is_list(object) do
    Enum.map(object, &snake_case_keys/1)
  end
  def snake_case_keys(object), do: object

  # Let's keep things nice and atom-y
  defp attempt_atom_conversion(string) do
    try do
      String.to_existing_atom(string)
    rescue
      ArgumentError -> String.to_atom(string)
    end
  end
end
