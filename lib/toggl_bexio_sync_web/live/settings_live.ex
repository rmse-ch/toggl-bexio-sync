defmodule TogglBexioSyncWeb.SettingsLive do
  use TogglBexioSyncWeb, :live_view

  alias TogglBexioSync.Accounts

  def render(assigns) do
    ~H"""
    <.header>Change Toggl API Token</.header>

    <.simple_form :let={f} id="toggl_token_form" for={@toggl_token_changeset} phx-submit="update_toggl_token" phx-change="validate_toggl_token">
      <.error :if={@toggl_token_changeset.action == :insert}>Something failed, please check below</.error>

      <.input field={{f, :toggl_api_token}} type="text" label="Toggl Token" required />

      <:actions>
        <.button phx-disable-with="Changing...">Change Toggl Token</.button>
      </:actions>
    </.simple_form>

    <.header class="mt-12">Webhook Authorization Token</.header>

    <p>Current Webhook-Token: </p>
    <div class="text-brand my-6 break-all"><%= @webhook_token %></div>
    <.button phx-click="generate_new_webhook_token">Generate Webhook Token</.button>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(:webhook_token, user.webhook_token)
      |> assign(:toggl_token_changeset, Accounts.toggl_token_changeset(user))

    {:ok, socket}
  end

  def handle_event("validate_toggl_token", %{"user" => user_params}, socket) do
    toggl_token_changeset = Accounts.toggl_token_changeset(socket.assigns.current_user, user_params)

    socket =
      assign(socket,
        toggl_token_changeset: Map.put(toggl_token_changeset, :action, :validate)
      )

    {:noreply, socket}
  end

  def handle_event("update_toggl_token", %{"user" => user_params}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_toggl_token(user, user_params["toggl_api_token"]) do
      {:ok, user} ->
        info = "The Toggl Token has been updated."
        {:noreply, put_flash(socket, :info, info)}

      {:error, changeset} ->
        IO.inspect changeset, label: "Error"
        {:noreply, assign(socket, :toggl_token_changeset, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("generate_new_webhook_token", _params, socket) do
    user = socket.assigns.current_user

    case Accounts.update_webhook_token(user) do
      {:ok, user} ->
        info = "The Webhook Token has been generated."
        {:noreply, put_flash(socket, :info, info)}

      {:error, changeset} ->
        IO.inspect changeset, label: "Error"
        {:noreply, assign(socket, :toggl_token_changeset, Map.put(changeset, :action, :insert))}
    end
  end

end
