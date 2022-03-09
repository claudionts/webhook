defmodule WebhookWeb.GithubDetailView do
  use WebhookWeb, :view

  def render("schedule_repo_detail.json", %{args: args}) do
    %{scheduling: true, repo_detail: args}
  end
end
