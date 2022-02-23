defmodule Webhook.ScheduleJob do
  # use Tesla, only: [:post], docs: false
  use Oban.Worker, queue: :events

  # alias WebhookWeb.Services.Github

  # plug Tesla.Middleware.BaseUrl, "https://webhook.site"
  # plug Tesla.Middleware.JSON

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"username" => _, "reponame" => _} = args}) do
    IO.inspect args
    # [{_, {:ok, body_issue}}, {_, {:ok, body_contributors}}] = Github.github_req(username, reponame)
    # post("/b6242316-cbb5-4dd8-ba5f-36ecce0c34e8", args)
    :ok
  end
end
