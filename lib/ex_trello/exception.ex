defmodule ExTrello.Error do
  defexception [:code, :message]
end

defmodule ExTrello.ConnectionError do
  defexception [:reason, message: "Connection error."]
end
