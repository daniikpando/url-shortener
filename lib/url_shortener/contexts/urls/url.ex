defmodule UrlShortener.Contexts.URLS.URL do
  use Ecto.Schema
  import Ecto.Changeset
  import UrlShortener.Utils.Ecto.ChangesetUtils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "urls" do
    field :hash, :string
    field :url, :string
    field :expired_at, :utc_datetime
    field :deleted, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:url, :hash])
    |> validate_required([:url, :hash])
    |> validate_url(:url)
  end
end
