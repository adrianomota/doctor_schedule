defmodule DoctorScheduleWeb.Api.SessionControllerTest do
  use DoctorScheduleWeb.ConnCase

  import DoctorScheduleWeb.Auth.Guardian
  import DoctorSchedule.Factory

  alias DoctorSchedule.Accounts

  setup %{conn: conn} do
    {:ok, user} =
      build(:user)
      |> Accounts.create_user()

    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
  end

  describe "sessions" do
    setup [:create_user]

    test "should authenticate with valid user", %{conn: conn, user: user} do
      conn =
        conn
        |> post(Routes.api_session_path(conn, :create), %{
          email: user.email,
          password: "123456"
        })

      assert json_response(conn, 201)["user"]["data"]["email"] == user.email
    end

    test "should not authenticate with invalid user", %{conn: conn, user: user} do
      conn =
        conn
        |> post(Routes.api_session_path(conn, :create), %{
          email: user.email,
          password: "123456789"
        })

      assert json_response(conn, 401) == "Unauthorized"
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
