defmodule TogglBexioSyncWeb.Router do
  use TogglBexioSyncWeb, :router

  import TogglBexioSyncWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TogglBexioSyncWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TogglBexioSyncWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", TogglBexioSyncWeb do
    pipe_through :api

    post "/toggl-webhook", TogglWebhookController, :webhook
  end

  # Other scopes may use custom stacks.
  # scope "/api", TogglBexioSyncWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:toggl_bexio_sync, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TogglBexioSyncWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # OAuth Routes
  scope "/auth", TogglBexioSyncWeb do
    pipe_through :browser

    get "/:provider", OAuthController, :request
    get "/:provider/callback", OAuthController, :callback
    post "/:provider/callback", OAuthController, :callback
    delete "/:provider/log_out", OAuthController, :delete
  end

  ## Authentication routes

  scope "/", TogglBexioSyncWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TogglBexioSyncWeb.UserAuth, :ensure_authenticated}] do

      live "/settings", SettingsLive
    end
  end

  scope "/", TogglBexioSyncWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{TogglBexioSyncWeb.UserAuth, :mount_current_user}] do
    end
  end
end
