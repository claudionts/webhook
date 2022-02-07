defmodule WebhookWeb.ScheduledRepoDetailController do
  use WebhookWeb, :controller

  alias WebhookWeb.Schedule

  action_fallback ElixirbankWeb.FallbackController

  @spec schedule_repo_detail(%Plug.Conn{}, %{username: String, reponame: String}) :: any()
  def schedule_repo_detail(conn, %{"username" => _, "reponame" => _} = params) do
    Schedule.repo_detail(params) |> IO.inspect()
  end
end
