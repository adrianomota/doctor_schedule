defmodule DoctorSchedule.Accounts.Services.Session do
  alias DoctorSchedule.{Accounts, Accounts.Entities.User}

  def authenticate(params, password) do
    user = Accounts.get_by!(params)

    if verify_user(user, password) do
      {:ok, user}
    else
      {:error}
    end
  rescue
    _ ->
      {:error, :unauthorized}
  end

  def verify_user(%User{password_hash: password_hash}, password),
    do: check_pass(password, password_hash)

  defp check_pass(password, password_hash), do: Bcrypt.verify_pass(password, password_hash)
end
