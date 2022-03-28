defmodule UrlShortenerWeb.ServiceLayer.URLService do
  alias UrlShortener.Contexts.URLS.URL
  alias UrlShortener.Contexts.URLS.URLManager
  alias Ecto.Changeset
  alias UrlShortenerWeb.Utils.HashAlgorithms

  @spec create_url(map) :: {:ok, URL.t()} | {:error, Changeset.t()}
  def create_url(url_params) do
    hash = add_hash_to_url(url_params["url"])

    url_params = Map.put(url_params, "hash", hash)

    with {:ok, %URL{} = url} <- create_or_get_url(url_params) do
      {:ok, url}
    end
  end

  defp add_hash_to_url(url) do
    url_combination = "#{url}-#{Ecto.UUID.generate()}"

    :md5
    |> HashAlgorithms.encode(url_combination)
    |> String.replace("=", "")
    |> String.slice(-7, 7)
  end

  @spec create_or_get_url(map()) ::
          {:ok, URL.t()} | {:error, Changeset.t()}
  defp create_or_get_url(%{"url" => url_value} = url_params) do
    case URLManager.get_url_by_long_url(url_value) do
      %URL{} = url ->
        {:ok, url}

      nil ->
        URLManager.create(url_params)
    end
  end
end
