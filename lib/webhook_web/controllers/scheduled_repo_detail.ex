defmodule WebhookWeb.ScheduledRepoDetail do
  use WebhookWeb, :controller

  action_fallback ElixirbankWeb.FallbackController

  @spec schedule_repo_detail(%Plug.Conn{}, %{username: String, reponame: String}) :: any()
  def schedule_repo_detail(conn, %{"username" => username, "reponame" => reponame}) do
  end
end
