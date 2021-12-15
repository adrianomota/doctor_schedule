defmodule DoctorSchedule.Factory do
  use ExMachina.Ecto, repo: DoctorSchedule.Repo

  alias Faker.{Avatar, Internet, Person}

  def user_factory do
    {:ok, %{email: email, first_name: first_name, last_name: last_name}} = get_email_user()

    %{
      email: email,
      avatar: Avatar.image_url(),
      first_name: first_name,
      last_name: last_name,
      password: "123456",
      password_confirmation: "123456",
      role: "user"
    }
  end

  defp get_email_user do
    first_name = Person.PtBr.first_name()
    last_name = Person.PtBr.last_name()
    email = "#{first_name}_#{last_name}@#{Internet.PtBr.free_email_service()}"
    {:ok, %{first_name: first_name, last_name: last_name, email: String.downcase(email)}}
  end
end
