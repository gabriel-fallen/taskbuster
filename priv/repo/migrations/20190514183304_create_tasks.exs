defmodule Taskbuster.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :owner_id, references(:users, on_delete: :delete_all), null: false
      add :assignee_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:owner_id])
    create index(:tasks, [:assignee_id])
  end
end
