defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string, null: false
      add :hash, :string, null: false
      add :expired_at, :utc_datetime, null: true
      add :deleted, :boolean, null: false, default: false

      timestamps()
    end
  end
end
