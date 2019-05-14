defmodule TaskbusterWeb.TaskController do
  use TaskbusterWeb, :controller

  alias Taskbuster.Tasks
  alias Taskbuster.Tasks.Task

  plug :authorize_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(conn.assigns.current_user, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, _) do
    changeset = Tasks.change_task(conn.assigns.task)
    render(conn, "edit.html", task: conn.assigns.task, changeset: changeset)
  end

  def update(conn, %{"task" => task_params}) do
    case Tasks.update_task(conn.assigns.task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: conn.assigns.task, changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _task} = Tasks.delete_task(conn.assigns.task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end

  defp authorize_owner(conn, _) do
    task = Tasks.get_task!(conn.params["id"])

    if conn.assigns.current_user.id == task.owner_id do
      assign(conn, :task, task)
    else
      conn
      |> put_flash(:error, "You can't modify that task")
      |> redirect(to: Routes.task_path(conn, :index))
      |> halt()
    end
  end
end
