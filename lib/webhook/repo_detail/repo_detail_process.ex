defmodule WebhookWeb.Schedule do
  alias GenStage

  alias WebhookWeb.Services.Github

  def repo_detail(%{"username" => username, "reponame" => reponame}) do
    with :ok <-
           Github.github_req(username, reponame)
         # {:ok, %Oban.Job{args: args}} <-
         #   schedule_job(username, reponame, body_issue, body_contributors) do
      # {:ok, args}
      do
      :ok
    else
      [{:error, _}, {:error, _}] = error_list -> hd error_list

      _ -> {:error, "Oban shedule error"}
    end
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
end
