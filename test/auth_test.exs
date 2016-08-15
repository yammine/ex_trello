defmodule ExTrello.AuthTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock

  setup_all do
    HTTPotion.start # Ensure :httpotion is started.

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
      token = ExTrello.request_token("http://localhost:4000/callback")

      assert token != nil
      assert token.oauth_token != nil
      assert token.oauth_token_secret != nil
      assert token.oauth_callback_confirmed != nil
    end
  end

  test "request token failure" do
    use_cassette "failed_connection", custom: true do
      assert_raise ExTrello.ConnectionError, "Connection error.", fn ->
        ExTrello.request_token("something")
      end
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
      ExTrello.access_token(verifier, token, token_secret)
    end
  end

  test "access token invalid input failure" do
    use_cassette "access_token_failure", custom: true do
      assert_raise ExTrello.Error, "request expired", fn ->
        ExTrello.access_token("some", "invalid", "stuff")
      end
    end
  end

  test "access token connection failure" do
    use_cassette "failed_connection", custom: true do
      assert_raise ExTrello.ConnectionError, "Connection error.", fn ->
        ExTrello.access_token("something", "strange", "in the neighborhood")
      end
    end
  end

end
