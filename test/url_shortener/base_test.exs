defmodule UrlShortener.BaseTest do
  use UrlShortener.DataCase

  alias UrlShortener.Base

  describe "urls" do
    alias UrlShortener.Base.Url

    @valid_attrs %{hash: "some hash", url: "some long_url"}
    @update_attrs %{hash: "some updated hash", url: "some updated long_url"}
    @invalid_attrs %{hash: nil, url: nil}

    def url_fixture(attrs \\ %{}) do
      {:ok, url} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Base.create()

      url
    end

    test "list/0 returns all urls" do
      url = url_fixture()
      assert Base.list() == [url]
    end

    test "get!/1 returns the url with given id" do
      url = url_fixture()
      assert Base.get!(url.id) == url
    end

    test "create/1 with valid data creates a url" do
      assert {:ok, %Url{} = url} = Base.create(@valid_attrs)
      assert url.hash == "some hash"
      assert urlurl == "some long_url"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Base.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the url" do
      url = url_fixture()
      assert {:ok, %Url{} = url} = Base.update(url, @update_attrs)
      assert url.hash == "some updated hash"
      assert urlurl == "some updated long_url"
    end

    test "update/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = Base.update(url, @invalid_attrs)
      assert url == Base.get!(url.id)
    end

    test "delete/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = Base.delete(url)
      assert_raise Ecto.NoResultsError, fn -> Base.get!(url.id) end
    end

    test "change/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = Base.change(url)
    end
  end
end
