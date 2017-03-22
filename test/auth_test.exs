defmodule ExTrello.AuthTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start # Ensure :httpoison is started.

    ExVCR.Config.filter_request_headers("Authorization")
    ExVCR.Config.filter_sensitive_data("oauth_signature=[^\"]+", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("access_token\":\".+?\"", "access_token\":\"<REMOVED>\"")
    ExVCR.Config.filter_sensitive_data("dsc=.+;", "<REMOVED>")
    ExVCR.Config.cassette_library_dir("fixtures/vcr_cassettes", "fixtures/custom_cassettes")

    ExTrello.configure(
      consumer_key:    System.get_env("TRELLO_CONSUMER_KEY"),
      consumer_secret: System.get_env("TRELLO_CONSUMER_SECRET")
    )

    :ok
  end

  test "Fetching request token from Trello" do
    use_cassette "request_token" do
      {:ok, token} = ExTrello.request_token("http://localhost:4000/callback")

      assert token != nil
      assert token.oauth_token != nil
      assert token.oauth_token_secret != nil
      assert token.oauth_callback_confirmed != nil
    end
  end

  test "request token connection failure" do
    use_cassette "failed_connection", custom: true do
      response = ExTrello.request_token("something")

      assert match?({:connection_error, %ExTrello.ConnectionError{reason: ["conn_failed", ["error", "nxdomain"]], message: "Connection error."}}, response)
    end
  end

  test "request token app not found failure" do
    use_cassette "request_token_app_not_found", custom: true do
      ExTrello.configure(consumer_key: "asdf", consumer_secret: "invalid_af")
      response = ExTrello.request_token("something")

      assert match?({:error, %ExTrello.Error{code: 500, message: "App not found"}}, response)
    end
  end

  test "generate an authorize_url" do
    # Checking the generated authorize url to the trello url pattern
    token = "a_token_yo"
    {:ok, regex} = Regex.compile("^https://api.trello.com/1/OAuthAuthorizeToken\\?oauth_token=" <> token)

    {:ok, authorize_url} = ExTrello.authorize_url(token)

    assert Regex.match?(regex, authorize_url)
  end

  test "validate access token" do
    use_cassette "access_token", custom: true do
      verifier     = "hey_its_me_ur_brother"
      token        = "pls"
      token_secret = "shh_dont_tell"
      {:ok, access_token} = ExTrello.access_token(verifier, token, token_secret)

      assert access_token.oauth_token == "aaaaaaaaaaaaaaaaaaaaa123"
      assert access_token.oauth_token_secret == "bbbbbbbbbbbbbbb32"
    end
  end

  test "access token invalid input failure" do
    use_cassette "access_token_failure", custom: true do
      response = ExTrello.access_token("some", "invalid", "stuff")

      assert match?({:error, %ExTrello.Error{code: 500, message: "request expired"}}, response)
    end
  end

  test "access token connection failure" do
    use_cassette "failed_connection", custom: true do
      response = ExTrello.access_token("something", "strange", "in the neighborhood")

      assert match?({:connection_error, %ExTrello.ConnectionError{reason: ["conn_failed", ["error", "nxdomain"]], message: "Connection error."}}, response)
    end
  end

end
