defmodule TaskbusterWeb.TaskChannel do
  use Phoenix.Channel

  def join("task:" <> task_id, _message, socket) do
    {_task_id, ""} = Integer.parse(task_id) # just to be sure
    {:ok, socket}
  end
  def join(_channel, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_comment", %{"username" => username, "body" => body}, socket) do
    broadcast!(socket, "new_comment", %{username: username, body: body})
    {:noreply, socket}
  end
end
