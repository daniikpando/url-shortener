defmodule UrlShortenerWeb.UrlLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Base
  alias UrlShortener.Base.Url

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :urls, Base.list_urls())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Url")
    |> assign(:url, Base.get_url!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Url")
    |> assign(:url, %Url{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Urls")
    |> assign(:url, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    url = Base.get_url!(id)
    {:ok, _} = Base.delete_url(url)

    {:noreply, assign(socket, :urls, Base.list_urls())}
  end
end
