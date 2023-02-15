defmodule TogglBexioSyncWeb.TogglWebhookController do
  use TogglBexioSyncWeb, :controller

  alias Plug.Conn

  def webhook(conn, params) do
    webhook_signature = Conn.get_req_header(conn, "x-webhook-signature-256")

    IO.inspect(webhook_signature, label: "Webhook Signature")
    IO.inspect(params, label: "Params in Webhook")

    render(conn, :ok, conn: conn, params: params)
  end
end
