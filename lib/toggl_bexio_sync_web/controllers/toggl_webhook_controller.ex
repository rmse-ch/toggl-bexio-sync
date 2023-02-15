defmodule TogglBexioSyncWeb.TogglWebhookController do
  use TogglBexioSyncWeb, :controller

  def webhook(conn, params) do

    IO.inspect(conn, label: "Conn Setup in Webhooks")
    IO.inspect(params, label: "Params in Webhook")

    render(conn, :ok, conn: conn, params: params)
  end
end
