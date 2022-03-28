defmodule UrlShortener.Utils.Ecto.ChangesetUtils do
  import Ecto.Changeset

  @spec validate_url(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_url(changeset, field) do
    url = changeset |> get_field(field)

    case url do
      nil ->
        changeset

      ^url ->
        # use regex to validate it.

        url_parsed = URI.parse(url)
        host = url_parsed.host || ""

        if url_parsed.scheme != nil and host =~ "." do
          changeset
        else
          add_error(changeset, field, "Invalid url")
        end
    end
  end
end
