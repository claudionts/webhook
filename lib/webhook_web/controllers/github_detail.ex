defmodule WebhookWeb.GithubDetail do
  use WebhookWeb, :controller

  alias WebhookWeb.Schedule

  action_fallback ElixirbankWeb.FallbackController

  @spec schedule_repo_detail(%Plug.Conn{}, %{username: String, reponame: String}) :: any()
  def schedule_repo_detail(conn, %{"username" => _, "reponame" => _} = params) do
    with :ok <- Schedule.repo_detail(params) do
      conn
      |> put_status(:ok)
      |> put_view(WebhookWeb.ScheduledRepoDetailView)
      |> render("schedule_repo_detail.json", args: %{"run" => "ok"})
    end
  end
end
