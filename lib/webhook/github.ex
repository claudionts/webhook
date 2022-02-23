defmodule Webhook.Github do
  alias GenStage

  alias Webhook.GithubProducer

  def repo_detail(%{"username" => _, "reponame" => _} = args) do
    with :ok <- schedule_job(args) do
      :ok
    end
  end

  defp schedule_job(args) do
    # %{
    #   "username" => username,
    #   "repository" => reponame,
    #   "issues" => Enum.map(body_issue, &issues_data(&1)),
    #   "contributors" => Enum.map(body_contributors, &contributor_data(&1))
    # }
    GithubProducer.send_message(args)
    |> IO.insert()
    :ok
  end
end
