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
        Map.put(acc, snake(key), snake_case_keys(value))
      {key, value}, acc when is_list(value) ->
        Map.put(acc, snake(key), Enum.map(value, &snake_case_keys/1))
      {key, value}, acc ->
        Map.put(acc, snake(key), value)
    end)
  end
  def snake_case_keys(object) when is_list(object) do
    Enum.map(object, &snake_case_keys/1)
  end
  def snake_case_keys(object), do: object

  defp snake(key) when is_atom(key),   do: Atom.to_string(key) |> snake
  defp snake(key) when is_binary(key), do: key |> do_snake

  defp do_snake(""), do: raise %ExTrello.Error{code: 500, message: "Failed parsing response from Trello."}
  defp do_snake(key), do: do_snake(key, "")

  defp do_snake(<< first::size(8), rest::binary >>, acc) when <<first>> in @capitalized_letters do
    do_snake(rest, acc <> "_" <> String.downcase(<<first>>))
  end
  defp do_snake(<< first::size(8), rest::binary >>, acc) do
    do_snake(rest, acc <> <<first>>)
  end
  defp do_snake("", acc), do: attempt_atom_conversion(acc)

  # Let's keep things nice and atom-y
  defp attempt_atom_conversion(string) do
    try do
      String.to_existing_atom(string)
    rescue
      ArgumentError -> String.to_atom(string)
    end
  end
end
