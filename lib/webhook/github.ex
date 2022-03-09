defmodule Webhook.Github do
  alias GenStage

  alias Webhook.GithubProducer

  def repo_detail(%{"username" => _, "reponame" => _} = args) do
    with :ok <- schedule_job(args) do
      :ok
    end
  end

  defp schedule_job(args) do
    Jason.encode!(args)
    |> GithubProducer.send_message()
    :ok
  end
end
