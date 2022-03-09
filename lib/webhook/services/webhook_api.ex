defmodule Webhook.Services.WebhookApi do
  use Tesla, only: [:post], docs: false

  plug Tesla.Middleware.BaseUrl, "https://webhook.site"
  plug Tesla.Middleware.JSON

  def send_webhook(body) do
    post("/ffa3d87c-b75c-4b11-956b-e4ef9fdb7c65", body)
  end
end
