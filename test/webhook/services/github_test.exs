defmodule Webhook.Services.GithubTest do
  @moduledoc false
  use ExUnit.Case

  alias Webhook.Services.Github

  describe "github_req/2" do
    test "return repos and issues correct" do
      reponame = "elixirbank"
      username = "claudionts"

      assert %{
               "issues" => _,
               "reponame" => ^reponame,
               "username" => ^username,
               "users" => _
             } = Github.github_req(username, reponame)
    end

    test "return repos and issues empty" do
      reponame = "elixirbank"
      username = "josevalim"

      assert %{
               "issues" => [[], []],
               "reponame" => ^reponame,
               "username" => ^username,
               "users" => [[], []]
             } = Github.github_req(username, reponame)
    end
  end
end
