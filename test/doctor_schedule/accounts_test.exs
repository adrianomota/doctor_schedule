defmodule DoctorSchedule.AccountsTest do
  use DoctorSchedule.DataCase

  import DoctorSchedule.Factory

  alias DoctorSchedule.{Accounts, Accounts.Entities.User}

  describe "users" do
    test "list_users/0 returns all users" do
      build(:user)
      |> Accounts.create_user()

      assert Accounts.list_users() |> Enum.count() > 0
    end

    test "get_user!/1 returns the user with given id" do
      {:ok, %{id: id} = user} =
        build(:user)
        |> Accounts.create_user()

      assert Accounts.get_user!(id).id == user.id
      assert Accounts.get_user!(id).first_name == user.first_name
      assert Accounts.get_user!(id).last_name == user.last_name
    end

    test "create_user/1 with valid data creates a user" do
      user = build(:user)

      assert {:ok, %User{}} = Accounts.create_user(user)
    end

    test "create_user/1 with invalid data returns error changeset" do
      user = build(:user, %{first_name: nil})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(user)
    end

    test "update_user/2 with valid data updates the user" do
      {:ok, user} =
        build(:user)
        |> Accounts.create_user()

      update_attrs = %{
        avatar: "some updated avatar",
        email: "semail@updated.com",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        role: "some updated role",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.avatar == "some updated avatar"
      assert user.email == "semail@updated.com"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      {:ok, %{id: id} = user} =
        build(:user)
        |> Accounts.create_user()

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{first_name: nil})

      assert Accounts.get_user!(id).id == user.id
      assert Accounts.get_user!(id).first_name == user.first_name
      assert Accounts.get_user!(id).last_name == user.last_name
    end

    test "delete_user/1 deletes the user" do
      {:ok, %{id: id} = user} =
        build(:user)
        |> Accounts.create_user()

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(id) end
    end

    test "change_user/1 returns a user changeset" do
      {:ok, user} =
        build(:user)
        |> Accounts.create_user()

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
