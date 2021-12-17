defmodule DoctorSchedule.Services.SessionTest do
  use DoctorSchedule.DataCase

  import DoctorSchedule.Factory

  alias DoctorSchedule.{
    Accounts,
    Accounts.Entities.User,
    Accounts.Services.Session
  }

  describe "Session" do
    setup [:create_user]

    test "authenticate/2", %{user: user} do
      assert {:ok, %User{}} = Session.authenticate(%{email: user.email}, "123456")
    end

    test "verify_user/2", %{user: user} do
      assert true == Session.verify_user(user, "123456")
    end

    test "verify_user/2 with invalid data", %{user: user} do
      assert false == Session.verify_user(user, "1234567")
    end

    test "authenticate/2 with invalid password", %{user: user} do
      assert {:error, :unauthorized} = Session.authenticate(%{email: user.email}, "123456789")
    end

    test "authenticate/2 with invalid user" do
      assert {:error, :unauthorized} =
               Session.authenticate(%{email: "not_found@doctor_schedule.com"}, "123456789")
    end
  end

  defp create_user(_) do
    {:ok, user} =
      build(:user, %{
        email: "user_logged@doctor_schedule.com",
        password: "123456",
        password_confirmation: "123456"
      })
      |> Accounts.create_user()

    %{user: user}
  end
end
