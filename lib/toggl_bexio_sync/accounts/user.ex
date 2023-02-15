defmodule TogglBexioSync.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:refresh_token, :string)
    field(:toggl_api_token, :string)
    field(:webhook_token, :string)
    field(:confirmed_at, :naive_datetime)

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :name, :refresh_token])
    |> validate_required(:refresh_token)
    |> validate_email(opts)
    |> create_webhook_token()
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, TogglBexioSync.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the refresh token.
  """
  def refresh_token_changeset(user, attrs) do
    user
    |> cast(attrs, [:refresh_token])
    |> validate_required([:refresh_token])
  end

  @doc """
  A user changeset for changing the toggl token.
  """
  def toggl_token_changeset(user, attrs) do
    user
    |> cast(attrs, [:toggl_api_token])
    |> validate_required([:toggl_api_token])
  end

  @doc """
  A user changeset to replace the webhook token.
  """
  def webhook_token_changeset(user) do
    user
    |> change()
    |> create_webhook_token()
  end

  defp create_webhook_token(changeset) do
    webhook_token =
      :crypto.strong_rand_bytes(256)
      |> Base.encode64()
      |> binary_part(0, 256)

    put_change(changeset, :webhook_token, webhook_token)
  end
end
