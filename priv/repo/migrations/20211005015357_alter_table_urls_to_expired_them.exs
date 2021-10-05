defmodule UrlShortener.Repo.Migrations.AlterTableUrlsToExpiredThem do
  use Ecto.Migration

  def change do
    alter table("urls") do
      add :expired_date, :utc_datetime, null: true
      add :deleted, :boolean, null: false, default: false
    end
  end
end
