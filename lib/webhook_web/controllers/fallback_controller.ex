defmodule WebhookWeb.FallbackController do
  use WebhookWeb, :controller

  @spec call(Plug.Conn, %{error: Atom, result: String}) :: any()
  def call(conn, {:error, result})  do
    conn
    |>put_status(:bad_request)
    |>put_view(WebhookWeb.ErrorView)
    |>render("400.json", result: result)
  end
end
