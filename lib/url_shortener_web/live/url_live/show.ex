defmodule UrlShortenerWeb.UrlLive.Show do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Contexts.URLS.URLManager

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:url, URLManager.get!(id))}
  end

  defp page_title(:show), do: "Show Url"
  defp page_title(:edit), do: "Edit Url"
end
