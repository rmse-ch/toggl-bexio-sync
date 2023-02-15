defmodule TogglBexioSyncWeb.OAuthController do
  use TogglBexioSyncWeb, :controller
  plug Ueberauth

  alias TogglBexioSync.Accounts
  alias TogglBexioSyncWeb.UserAuth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect(conn, label: "Callback Connection")

    %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: email
      },
      credentials: %Ueberauth.Auth.Credentials{
        refresh_token: refresh_token
      }
    } = auth

    if user = Accounts.get_user_by_email(email) do
      UserAuth.log_in_user(conn, user, refresh_token)
    else
      UserAuth.create_and_log_in_user(conn, email, refresh_token)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
