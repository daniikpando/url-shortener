defmodule UrlShortenerWeb.UrlLive.FormComponent do
  use UrlShortenerWeb, :live_component
  import Ecto.Changeset
  import UrlShortener.Utils.Ecto.ChangesetUtils

  alias UrlShortenerWeb.ServiceLayer.URLService
  alias UrlShortener.Contexts.URLS.URLManager

  def update(%{url: url_schema} = assigns, socket) do
    {:ok,
     assign(socket, Map.put(assigns, :changeset, custom_changeset(%{"url" => url_schema.url})))}
  end

  def handle_event("validate", %{"url" => url_params}, socket) do
    changeset = custom_changeset(url_params)

    changeset = Map.put(changeset, :action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"url" => url_params}, socket) do
    save_url(socket, socket.assigns.action, url_params)
  end

  defp save_url(socket, :edit, url_params) do
    case URLManager.update(socket.assigns.url, url_params) do
      {:ok, _url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Url updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Internal server error")}
    end
  end

  defp save_url(socket, :new, url_params) do
    case URLService.create_url(url_params) do
      {:ok, _url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Url created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Internal server error")}
    end
  end

  defp custom_changeset(params) do
    data = %{}

    types = %{
      url: :string
    }

    {data, types}
    |> cast(params, [:url])
    |> validate_required([:url])
    |> validate_url(:url)
  end
end
