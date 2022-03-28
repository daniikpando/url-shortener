defmodule UrlShortenerWeb.UrlLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Contexts.URLS.URL
  alias UrlShortener.Contexts.URLS.URLManager

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :urls, URLManager.list())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Url")
    |> assign(:url, URLManager.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Url")
    |> assign(:url, %URL{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Urls")
    |> assign(:url, nil)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    url = URLManager.get!(id)
    {:ok, _} = URLManager.delete(url)

    {:noreply, assign(socket, :urls, URLManager.list())}
  end
end
