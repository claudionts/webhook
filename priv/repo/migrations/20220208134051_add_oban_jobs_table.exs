defmodule Webhook.Repo.Migrations.AddObanJobsTable do
  use Ecto.Migration

  def change do
    Oban.Migrations.up()
  end

  def down do
    Oban.Migrations.down(version: 1)
  end
end