defmodule DoctorSchedule.Accounts.Entities.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :avatar, :string
    field :email, :string, unique: true
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"

    timestamps()
  end

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :avatar,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> validate_required([
      :email,
      :avatar,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:password, min: 6, max: 255)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
