defmodule Webhook.Services.Github do
  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/repos"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization", "Bearer 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"},
    {"User-Agent", "webhook"}
  ]

  def github_req(username, reponame) do
    [
      {_, {:ok, {:ok, %Tesla.Env{body: body_contributors}}}},
      {_, {:ok, {:ok, %Tesla.Env{body: body_issues}}}}
    ] =
      [
        Task.async(fn -> request(username, reponame, "contributors") end),
        Task.async(fn -> request(username, reponame, "issues") end)
      ]
      |> Task.yield_many()

    %{
      "users" => Enum.map(body_contributors, fn contributor -> contributor_data(contributor) end),
      "issues" => Enum.map(body_issues, fn issue -> issues_data(issue) end),
      "username" => username,
      "reponame" => reponame
    }
  end

  @spec request(String.t(), String.t(), String.t()) :: {:ok, List.t()} | {:error, String.t()}
  def request(username, reponame, endpoint) when endpoint in ["contributors", "issues"] do
    get("/#{username}/#{reponame}/#{endpoint}")
  end

  @spec issues_data(map) :: map
  defp issues_data(%{
         "title" => title,
         "user" => %{
           "html_url" => html_url
         },
         "labels" => labels
       }) do
    %{
      "title" => title,
      "author" => html_url,
      "labels" => Enum.map(labels, fn %{"name" => name} -> name end)
    }
  end

  @spec issues_data(list) :: list
  defp issues_data({_, _}) do
    "Issues not exists"
  end

  @spec contributor_data(map) :: map
  defp contributor_data(%{
         "login" => login,
         "contributions" => contributions,
         "html_url" => html_url
       }) do
    %{"name" => login, "user" => html_url, "qtd_commits" => contributions}
  end

  @spec contributor_data(list) :: list
  defp contributor_data({_, _}) do
    "Contributor not exists"
  end
end
