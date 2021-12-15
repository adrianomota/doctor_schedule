defmodule DoctorScheduleWeb.UserControllerTest do
  use DoctorScheduleWeb.ConnCase

  import DoctorSchedule.Factory

  alias DoctorSchedule.{Accounts, Accounts.Entities.User}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user = build(:user)
      conn = post(conn, Routes.user_path(conn, :create), user: user)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{first_name: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      update_attrs = %{
        avatar: "some updated avatar",
        email: "semail@updated.com",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        role: "some updated role",
        password: "123456",
        password_confirmation: "123456"
      }

      conn = put(conn, Routes.user_path(conn, :update, user), user: update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "first_name" => "some updated first_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{email: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    {:ok, user} =
      build(:user)
      |> Accounts.create_user()

    %{user: user}
  end
end
