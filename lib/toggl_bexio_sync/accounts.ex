defmodule TogglBexioSync.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TogglBexioSync.Repo

  alias TogglBexioSync.Accounts.{User, UserToken}

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a new user.

  ## Examples

      iex> create_user()"freddy@hotmail.com", "1122334")
      {:ok, %User{email: "freddy@hotmail.com", refresh_token: "1122334"}}
  """
  def create_user(email, refresh_token) do
    %User{}
    |> User.registration_changeset(%{email: email, refresh_token: refresh_token})
    |> Repo.insert()
  end

  @doc """
  Updates the user with a new refresh token.

  ## Examples

      iex> update_refresh_token(%User{}, "1122334")
      {:ok, %User{refresh_token: "1122334"}}
  """
  def update_refresh_token(user, nil), do: {:ok, user}

  def update_refresh_token(user, refresh_token) do
    user
    |> User.refresh_token_changeset(%{refresh_token: refresh_token})
    |> Repo.update()
  end

  @doc """
  Updates the user with a new webhook token,

  ## Examples

      iex> update_webhook_token(%User{})
      {:ok, %User{webhook_token: "12345"}}
  """
  def update_webhook_token(user) do
    user
    |> User.webhook_token_changeset()
    |> Repo.update()
  end

  @doc """
  Updates the user with a new Toggl API Token,

  ## Examples

      iex> update_toggl_token(%User{}, "12345)
      {:ok, %User{toggl_token: "12345"}}
  """
  def update_toggl_token(user, toggl_api_token) do
    user
    |> User.toggl_token_changeset(%{toggl_api_token: toggl_api_token})
    |> Repo.update()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  def toggl_token_changeset(user, attrs \\ %{}) do
    User.toggl_token_changeset(user, attrs)
  end

  def webhook_token_changeset(user) do
    User.webhook_token_changeset(user)
  end
end
