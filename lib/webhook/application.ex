defmodule Webhook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Webhook.Repo,
      # Start the Telemetry supervisor
      WebhookWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Webhook.PubSub},
      # Start the Endpoint (http/https)
      WebhookWeb.Endpoint
      # Start a worker by calling: Webhook.Worker.start_link(arg)
      # {Webhook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webhook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WebhookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
