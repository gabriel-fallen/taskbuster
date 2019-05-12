defmodule TaskbusterWeb.LayoutView do
  use TaskbusterWeb, :view

  defp logged_in?(conn) do
    case Plug.Conn.get_session(conn, :current_user_id) do
      nil -> false
      _   -> true
    end
  end
end
