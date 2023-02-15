defmodule TogglBexioSyncWeb.PageController do
  use TogglBexioSyncWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(assign(conn, :page_title, "Welcome"), :home)
  end
end
