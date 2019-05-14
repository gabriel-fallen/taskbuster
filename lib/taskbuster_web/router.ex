defmodule TaskbusterWeb.Router do
  use TaskbusterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskbusterWeb do
    pipe_through :browser

    get "/", PageController, :index

    # accounts
    resources "/users", UserController
    resources "/login", LoginController, only: [:create, :delete, :new], singleton: true
  end

  scope "/", TaskbusterWeb do
    pipe_through [:browser, :authenticate_user]

    # tasks
    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskbusterWeb do
  #   pipe_through :api
  # end

  defp authenticate_user(conn, _) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, Taskbuster.Accounts.get_user!(user_id))
    end
  end
end
