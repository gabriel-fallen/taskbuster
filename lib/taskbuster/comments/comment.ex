defmodule Taskbuster.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Taskbuster.Accounts.User
  alias Taskbuster.Tasks.Task

  schema "comments" do
    field :body, :string
    belongs_to :author, User
    belongs_to :task, Task

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
