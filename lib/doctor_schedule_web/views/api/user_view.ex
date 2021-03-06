defmodule DoctorScheduleWeb.Api.UserView do
  use DoctorScheduleWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      avatar: user.avatar,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role
    }
  end
end
