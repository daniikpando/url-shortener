defmodule UrlShortener.Base.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :hash, :string
    field :long_url, :string

    timestamps()
  end

  @doc false
  def validate_changeset(url, attrs) do
    url
    |> cast(attrs, [:long_url, :hash])
    |> validate_required([:long_url, :hash])
  end

  def create_changeset(url, attrs) do
    url
    |> validate_changeset(attrs)
    |> validate_change(:long_url, fn :long_url, long_url ->
      case long_url do
        l when is_binary(l) ->

          uri = URI.parse(l)
          if uri.scheme != nil && uri.host =~ "." do
            []
          else
            [long_url: "Invalid url"]
          end

        _ -> [long_url: "Invalid type of url"]
      end
    end)
  end
end
