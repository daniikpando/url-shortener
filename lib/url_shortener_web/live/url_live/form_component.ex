defmodule UrlShortenerWeb.UrlLive.FormComponent do
  use UrlShortenerWeb, :live_component
  alias UrlShortenerWeb.ServiceLayer.URLService

  alias UrlShortener.Base

  @impl true
  def update(%{url: url} = assigns, socket) do
    {_, changeset} = Base.change_url(url)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"url" => url_params}, socket) do
    {_, changeset} =
      socket.assigns.url
      |> Base.change_url(url_params)

    changeset =
      changeset
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"url" => url_params}, socket) do
    save_url(socket, socket.assigns.action, url_params)
  end

  defp save_url(socket, :edit, url_params) do
    case Base.update_url(socket.assigns.url, url_params) do
      {:ok, _url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Url updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_url(socket, :new, url_params) do
    case URLService.create_url(url_params) do
      {:ok, _url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Url created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
