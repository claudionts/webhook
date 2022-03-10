defmodule Webhook.Services.WebhookApiTest do
  @moduledoc false
  use ExUnit.Case

  alias Webhook.Services.WebhookApi

  describe "send_webhook/1" do
    test "request with body" do
      assert {:ok, %Tesla.Env{status: 200}} = WebhookApi.send_webhook(%{"test" => "ok"})
    end
  end
end
