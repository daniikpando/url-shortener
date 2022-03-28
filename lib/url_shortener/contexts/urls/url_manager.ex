defmodule UrlShortener.Contexts.URLS.URLManager do
  @moduledoc """
  The Base context.
  """

  import Ecto.Query, warn: false

  alias UrlShortener.Contexts.URLS.URL
  alias UrlShortener.Repo

  @doc """
  Returns the list of urls.

  ## Examples

      iex> list()
      [%URL{}, ...]

  """
  def list do
    Repo.all(URL)
  end

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get!(123)
      %Url{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(URL, id)

  @doc """
  Creates a url.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Url{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs), do: %URL{} |> URL.changeset(attrs) |> Repo.insert()

  @doc """
  Updates a url.

  ## Examples

      iex> update(url, %{field: new_value})
      {:ok, %Url{}}

      iex> update(url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%URL{} = url, attrs) do
    url
    |> URL.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete(url)
      {:ok, %Url{}}

      iex> delete(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%URL{} = url) do
    Repo.delete(url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change(url)
      %Ecto.Changeset{data: %Url{}}

  """
  def change(%URL{} = url, attrs \\ %{}) do
    URL.changeset(url, attrs)
  end

  @spec get_url_by_long_url(String.t()) :: URL.t()
  def get_url_by_long_url(long_url) do
    query =
      from(u in URL,
        where: u.url == ^long_url,
        where: not u.deleted
      )

    Repo.one(query)
  end

  def expire_urls do
    datetime_now = DateTime.utc_now()

    query =
      from(u in URL,
        where:
          fragment("(? AT TIME ZONE 'UTC')::date + interval '1 month'", u.inserted_at) <
            ^datetime_now
      )

    Repo.update_all(query, set: [deleted: true, expired_at: datetime_now])
  end
end
