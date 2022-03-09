defmodule Webhook.Services.GithubTest do
  @moduledoc false
  use ExUnit.Case

  alias Webhook.Services.Github

  describe "request/3" do
    Enum.map(
      [
        {"claudionts", "elixirbank", "contributors"},
        {"claudionts", "elixirbank", "issues"}
      ],
      fn {username, reponame, endpoint} ->
        test "request to #{endpoint} endpoint" do
          assert {:ok, %Tesla.Env{body: _}} =
                   Github.request(unquote(username), unquote(reponame), unquote(endpoint))
        end
      end
    )
  end
end
