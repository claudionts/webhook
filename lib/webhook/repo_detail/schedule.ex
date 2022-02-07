defmodule WebhookWeb.Schedule do
  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/repos"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization", "Bearer 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"},
    {"User-Agent", "webhook"}
  ]

  def repo_detail(%{"username" => username, "reponame" => reponame}) do
    [{_, {:ok, body_issue}}, {_, {:ok, body_contributors}}] = [
      Task.async(fn -> get_issue(username, reponame) end),
      Task.async(fn -> get_contributors(username, reponame) end)
    ]
    |> Task.yield_many()

    %{"username" => username, "repository" => reponame, "issues" => body_issue, "contributors" => body_contributors}
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

  @spec handle_response(%Tesla.Env{}, String.t()) :: {:ok, %Tesla.Env{}} | {:error, String.t()}  
  defp handle_response(params, process) do
    case params do
       {:ok, %Tesla.Env{body: body}} -> body
      _ -> {:error, "#{process} request not found"}
    end
  end
end
