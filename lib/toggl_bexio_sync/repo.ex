defmodule TogglBexioSync.Repo do
  use Ecto.Repo,
    otp_app: :toggl_bexio_sync,
    adapter: Ecto.Adapters.Postgres
end
