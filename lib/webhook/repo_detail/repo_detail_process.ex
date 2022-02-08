defmodule WebhookWeb.Schedule do
  use Tesla, only: [:get], docs: false
  alias GenStage

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/repos"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization", "Bearer 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"},
    {"User-Agent", "webhook"}
  ]

  def repo_detail(%{"username" => username, "reponame" => reponame}) do
    with [{_, {:ok, body_issue}}, {_, {:ok, body_contributors}}] <-
           github_req(username, reponame),
         {:ok, %Oban.Job{args: args}} <-
           schedule_job(username, reponame, body_issue, body_contributors) do
      {:ok, args}
    else
      [{:error, _}, {:error, _}] = error_list -> hd error_list

      _ -> {:error, "Oban shedule error"}
    end
  end

  defp github_req(username, reponame) do
    [
      Task.async(fn -> get_issue(username, reponame) end),
      Task.async(fn -> get_contributors(username, reponame) end)
    ]
    |> Task.yield_many()
  end

  defp schedule_job(username, reponame, body_issue, body_contributors) do
    date_schedule = DateTime.utc_now |> DateTime.add(1*24*60*60, :second)
    %{
      "username" => username,
      "repository" => reponame,
      "issues" => Enum.map(body_issue, &issues_data(&1)),
      "contributors" => Enum.map(body_contributors, &contributor_data(&1))
    }
    |> Webhook.ScheduleJob.new(scheduled_at: date_schedule)
    |> Oban.insert()
  end

  @spec get_contributors(String.t(), String.t()) :: {:ok, List.t()} | {:error, String.t()}
  defp get_issue(username, reponame) do
    get("/#{username}/#{reponame}/issues")
    |> handle_response("issues")
  end

  @spec get_contributors(String.t(), String.t()) :: {:ok, List.t()} | {:error, String.t()}
  defp get_contributors(username, reponame) do
    get("/#{username}/#{reponame}/contributors")
    |> handle_response("contributors")
  end

  @spec issues_data(map) :: map
  defp issues_data(%{
         "title" => title,
         "user" => %{
           "html_url" => html_url
         },
         "labels" => [%{"name" => name}]
       }) do
    %{"title" => title, "author" => html_url, "labels" => [name]}
  end

  @spec contributor_data(map) :: map
  defp contributor_data(%{
         "login" => login,
         "contributions" => contributions,
         "html_url" => html_url
       }) do
    %{"name" => login, "user" => html_url, "qtd_commits" => contributions}
  end

  @spec handle_response(%Tesla.Env{}, String.t()) :: {:ok, %Tesla.Env{}} | {:error, String.t()}
  defp handle_response(params, process) do
    case params do
      {:ok, %Tesla.Env{body: body}} -> body
      _ -> {:error, "#{process} request not found"}
    end
  end
end
