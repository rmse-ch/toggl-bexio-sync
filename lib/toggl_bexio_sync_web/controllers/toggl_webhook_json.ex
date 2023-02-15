defmodule TogglBexioSyncWeb.TogglWebhookJSON do
  def ok(%{conn: conn, params: params}) do
    %{conn: inspect(conn), params: inspect(params)}
  end
end
