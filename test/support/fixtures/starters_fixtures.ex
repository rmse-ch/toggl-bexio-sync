defmodule TogglBexioSync.StartersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TogglBexioSync.Starters` context.
  """

  @doc """
  Generate a starter.
  """
  def starter_fixture(attrs \\ %{}) do
    {:ok, starter} =
      attrs
      |> Enum.into(%{
        name: "some name",
        something: ~N[2023-02-14 16:46:00]
      })
      |> TogglBexioSync.Starters.create_starter()

    starter
  end
end
