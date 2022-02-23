defmodule WebhookWeb.Services.Github do
  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/repos"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization", "Bearer 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"},
    {"User-Agent", "webhook"}
  ]

  def github_req(username, reponame) do
    [{_, {:ok, body_issue}}, {_, {:ok, body_contributors}}] = [
      Task.async(fn -> request(username, reponame, "contributors") end),
      Task.async(fn -> request(username, reponame, "issues") end)
    ]
    |> Task.yield_many()
  end

  @spec request(String.t(), String.t(), String.t()) :: {:ok, List.t()} | {:error, String.t()}
  defp request(username, reponame, endpoint) when endpoint in ["contributors", "issues"] do
    get("/#{username}/#{reponame}/#{endpoint}")
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
