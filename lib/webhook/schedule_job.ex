defmodule Webhook.ScheduleJob do
  # use Tesla, only: [:post], docs: false
  use Oban.Worker, queue: :events

  alias Webhook.Services.Github
  alias Webhook.Services.WebhookApi

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"username" => username, "reponame" => reponame}}) do
    Github.github_req(username, reponame)
    |> WebhookApi.send_webhook()
    :ok
  end
end
