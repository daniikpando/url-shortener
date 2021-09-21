defmodule UrlShortener.BaseTest do
  use UrlShortener.DataCase

  alias UrlShortener.Base

  describe "urls" do
    alias UrlShortener.Base.Url

    @valid_attrs %{hash: "some hash", long_url: "some long_url"}
    @update_attrs %{hash: "some updated hash", long_url: "some updated long_url"}
    @invalid_attrs %{hash: nil, long_url: nil}

    def url_fixture(attrs \\ %{}) do
      {:ok, url} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Base.create_url()

      url
    end

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert Base.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert Base.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      assert {:ok, %Url{} = url} = Base.create_url(@valid_attrs)
      assert url.hash == "some hash"
      assert url.long_url == "some long_url"
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Base.create_url(@invalid_attrs)
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      assert {:ok, %Url{} = url} = Base.update_url(url, @update_attrs)
      assert url.hash == "some updated hash"
      assert url.long_url == "some updated long_url"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = Base.update_url(url, @invalid_attrs)
      assert url == Base.get_url!(url.id)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = Base.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> Base.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = Base.change_url(url)
    end
  end
end
