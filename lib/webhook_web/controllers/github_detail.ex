defmodule WebhookWeb.GithubDetailController do
  use WebhookWeb, :controller

  alias Webhook.Github

  action_fallback ElixirbankWeb.FallbackController

  @spec schedule_repo_detail(%Plug.Conn{}, %{username: String, reponame: String}) :: any()
  def schedule_repo_detail(conn, %{"username" => _, "reponame" => _} = params) do
    with :ok <- Github.repo_detail(params) do
      conn
      |> put_status(:ok)
      |> put_view(WebhookWeb.GithubDetailView)
      |> render("schedule_repo_detail.json", args: %{"run" => "ok"})
    end
  end
end
