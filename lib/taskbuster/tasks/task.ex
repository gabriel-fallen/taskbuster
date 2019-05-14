defmodule Taskbuster.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Taskbuster.Accounts.User

  schema "tasks" do
    field :description, :string
    field :title, :string
    belongs_to :owner, User
    belongs_to :assignee, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
