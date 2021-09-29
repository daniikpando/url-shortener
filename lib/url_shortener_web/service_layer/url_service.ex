defmodule UrlShortenerWeb.ServiceLayer.URLService do
  alias UrlShortener.Base.Url
  alias UrlShortener.Base
  alias Ecto.Changeset
  alias UrlShortenerWeb.Utils.HashAlgorithms
  @base_hash "0000000"

  defp assign_hash_url(%Url{id: id}) do
    # TODO: consider to manager other algorithms like bloom filter using crc32 and others
    HashAlgorithms.encode(id, :base62)
  end

  defp assign_hash_url(_) do
    {:error, "Internal error"}
  end

  @spec create_or_get_url(Changeset.t()) ::
          {:error, Ecto.Changeset.t()} | {:ok, Changeset.t() | Url.t(), :new | :already_exists}
  defp create_or_get_url(%Changeset{changes: url_obj} = changeset) do
    case Base.get_url_by_long_url(url_obj) do
      %Url{hash: @base_hash} = url ->
        {:ok, url, :new}

      %Url{} = url ->
        {:ok, url, :already_exists}

      _ ->
        {state, url_or_changeset} = changeset |> Base.create_url()
        {state, url_or_changeset, :new}
    end
  end

  @spec create_url(map) :: {} | {:error, Ecto.Changeset.t()} | {:ok, any}
  def create_url(url_params) do
    with {:ok, %Changeset{} = changeset} <-
           Base.validate_before_create_url(%Url{}, Map.put(url_params, "hash", @base_hash)),
         {:ok, %Url{} = url, :new} <- create_or_get_url(changeset),
         {:ok, hash_url} <- assign_hash_url(url) do
      Base.update_url(url, %{"hash" => hash_url})
    else
      {:ok, url, :already_exists} -> {:ok, url}
      {:error, _} = error -> error
      {:error, err, _} -> {:error, err}
    end
  end
end
