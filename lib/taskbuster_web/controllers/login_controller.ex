defmodule TaskbusterWeb.LoginController do
  use TaskbusterWeb, :controller

  alias Taskbuster.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    case Accounts.authenticate_by_name_password(auth_params["username"], auth_params["password"]) do
    {:ok, user} ->
      conn
      |> put_session(:current_user_id, user.id)
      |> put_flash(:info, "Signed in successfully.")
      |> redirect(to: Routes.page_path(conn, :index))
    {:error, reason} ->
      conn
      |> put_flash(:error, reason)
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
