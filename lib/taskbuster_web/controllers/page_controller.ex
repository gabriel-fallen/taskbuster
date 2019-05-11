defmodule TaskbusterWeb.PageController do
  use TaskbusterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
