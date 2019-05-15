defmodule TaskbusterWeb.CommentController do
  use TaskbusterWeb, :controller

  alias Taskbuster.Comments
  alias Taskbuster.Comments.Comment

  plug :authorize_author when action in [:edit, :update, :delete]

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task_id" => task_id, "comment" => comment_params}) do
    {task_id, ""} = Integer.parse(task_id)
    case Comments.create_comment(conn.assigns.current_user, task_id, comment_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, _) do
    changeset = Comments.change_comment(conn.assigns.comment)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"task_id" => task_id, "comment" => comment_params}) do
    case Comments.update_comment(conn.assigns.comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.task_comment_path(conn, :show, task_id, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"task_id" => task_id}) do
    {:ok, _comment} = Comments.delete_comment(conn.assigns.comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :show, task_id))
  end

  defp authorize_author(conn, _) do
    comment = Comments.get_comment!(conn.params["id"])

    if conn.assigns.current_user.id == comment.author_id do
      assign(conn, :comment, comment)
    else
      conn
      |> put_flash(:error, "You can't modify that comment")
      |> redirect(to: Routes.task_path(conn, :show, conn.params["task_id"]))
      |> halt()
    end
  end
end
