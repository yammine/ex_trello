defmodule ExTrello.ConfigTest do
  use ExUnit.Case

  describe "Configuration testing" do

    test "global configuration" do
      credentials = [consumer_key: "test", consumer_secret: "test", token: "test", token_secret: "test"]
      ExTrello.configure(credentials)

      assert ExTrello.Config.current_scope == :global
      assert ExTrello.Config.get == credentials
    end

    test "setting process configuration doesn't pollute global config" do
      test_pid = self
      test_fun = fn(pid, config) ->
        spawn(fn() ->
          ExTrello.configure(:process, config)
          send(pid, {ExTrello.Config.current_scope, ExTrello.Config.get})
        end)
      end

      p1_config = [consumer_key: "test1", consumer_secret: "test1", token: "test1", token_secret: "test1"]
      p2_config = [consumer_key: "test2", consumer_secret: "test2", token: "test2", token_secret: "test2"]

      test_fun.(test_pid, p1_config)
      test_fun.(test_pid, p2_config)

      assert_receive {:process, p1_config}
      assert_receive {:process, p2_config}
    end

    test "complains if credentials are not set" do
      ExTrello.configure([])

      assert_raise ExTrello.Error, "OAuth parameters are not set. Use ExTrello.configure function to set parameters in advance.", fn ->
        ExTrello.member()
      end
    end

  end

end
