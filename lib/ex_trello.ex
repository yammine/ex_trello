defmodule ExTrello do
  @moduledoc """
  Provides access interface to the Trello API.
  """
  use Application

  @doc """
  false
  """
  def start(_type, _args) do
    ExTrello.Supervisor.start_link
  end

  # -------------- ExTrello Settings -------------

  @doc """
  Provides OAuth configuration settings for accessing trello server.

  The specified configuration applies globally. Use `ExTrello.configure/2`
  for setting different configurations on each processes.

  ## Examples

      ExTrello.configure(
        app_key: System.get_env("TRELLO_APP_KEY"),
        app_secret: System.get_env("TRELLO_APP_SECRET"),
        access_token: System.get_env("TRELLO_ACCESS_TOKEN"),
        access_token_secret: System.get_env("TRELLO_ACCESS_SECRET")
      )
  """

  @spec configure(Keyword.t) :: :ok
  defdelegate configure(oauth), to: ExTrello.Config, as: :set

  @doc """
  Provides OAuth configuration settings for accessing trello server.

  ## Options

    The `scope` can have one of the following values.

    * `:global` - configuration is shared for all processes.

    * `:process` - configuration is isolated for each process.

  ## Examples

      ExTrello.configure(
        :process,
        app_key: System.get_env("TRELLO_APP_KEY"),
        app_secret: System.get_env("TRELLO_APP_SECRET"),
        access_token: System.get_env("TRELLO_ACCESS_TOKEN"),
        access_token_secret: System.get_env("TRELLO_ACCESS_SECRET")
      )

  """

  @spec configure(:global | :process, Keyword.t) :: :ok
  defdelegate configure(scope, oauth), to: ExTrello.Config, as: :set

  @doc """
  POST OAuthGetRequestToken

  ## Examples

      ExTrello.request_token()

  ## Reference
  https://trello.com/app-key
  """

  @spec request_token() :: [ExTrello.Model.RequestToken.t]
  defdelegate request_token(), to: ExTrello.API.Auth

  @doc """
  GET OAuthAuthorizeToken

  ## Examples

      token = ExTrello.request_token
      ExTrello.authorize_url(token.oauth_token, %{return_url: "http://localhost:4000/auth/trello/callback/1234", scope: "read,write", expiration: "never", name: "Example Authentication"})

  Returns the URL you should redirect the user to for authorization
  """
  @spec authorize_url(String.t, Map.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate authorize_url(oauth_token, options), to: ExTrello.API.Auth

  @doc """
  GET OAuthAuthorizeToken

  ## Examples

      token = ExTrello.request_token
      ExTrello.authorize_url(token.oauth_token)

  Returns the URL you should redirect the user to for authorization
  """
  @spec authorize_url(String.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate authorize_url(oauth_token), to: ExTrello.API.Auth

  @doc """
  POST OAuthGetAccessToken

  ## Examples

      ExTrello.access_token("OAUTH_VERIFIER", "OAUTH_TOKEN")
  """
  @spec access_token(String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate access_token(verifier, request_token), to: ExTrello.API.Auth

end
