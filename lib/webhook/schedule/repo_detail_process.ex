defmodule Webhook.Schedule do
  alias GenStage

  alias WebhookWeb.Services.Github

  def repo_detail(%{"username" => username, "reponame" => reponame}) do
    with :ok <- Github.github_req(username, reponame) do
      {:ok, args}
      do
      :ok
  end
end
