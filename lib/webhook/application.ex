defmodule Webhook.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Webhook.Repo,
      WebhookWeb.Telemetry,
      {Phoenix.PubSub, name: Webhook.PubSub},
      {Oban, oban_config()},
      WebhookWeb.Endpoint,
    ]

    opts = [strategy: :one_for_one, name: Webhook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    WebhookWeb.Endpoint.config_change(changed, removed)
    :ok
  end

 defp oban_config do
    Application.fetch_env!(:webhook, Oban)
  end
end
