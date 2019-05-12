defmodule Taskbuster.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :binary
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:username, min: 3, max: 15)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> update_change(:password, fn p -> :crypto.hash(:sha, p) end)
  end
end
