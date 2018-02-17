defmodule Shining.Shining.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shining.Shining.Accounts.User


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password, :username])
    |> validate_required([:email, :encrypted_password, :username])
  end
end
