defmodule DoctorSchedule.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :avatar, :string
      add :first_name, :string
      add :last_name, :string
      add :password_hash, :string
      add :role, :string

      timestamps()
    end
  end
end
