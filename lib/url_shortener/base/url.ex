defmodule UrlShortener.Base.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :hash, :string
    field :long_url, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:long_url, :hash])
    |> validate_required([:long_url, :hash])
  end
end
