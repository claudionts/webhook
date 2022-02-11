defmodule WebhookWeb.Services.Github do

  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/repos"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization", "Bearer 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"},
    {"User-Agent", "webhook"}
  ]

  def github_req(username, reponame) do
    [
      Task.async(fn -> request(username, reponame, "contributors") end),
      Task.async(fn -> request(username, reponame, "issues") end)
    ] |> IO.inspect()
    :ok
  end

  @spec request(String.t(), String.t(), String.t()) :: {:ok, List.t()} | {:error, String.t()}
  defp request(username, reponame, endpoint) when endpoint in ["contributors", "issues"] do
    get("/#{username}/#{reponame}/#{endpoint}")
    |> handle_response("issues")
  end

  @spec handle_response(%Tesla.Env{}, String.t()) :: {:ok, %Tesla.Env{}} | {:error, String.t()}
  defp handle_response(params, process) do
    case params do
      {:ok, %Tesla.Env{body: body}} -> body
      _ -> {:error, "#{process} request not found"}
    end
  end
end
