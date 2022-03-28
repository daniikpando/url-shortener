defmodule UrlShortener.Worker.ExpireUrls do
  use GenServer

  alias UrlShortener.Contexts.URLS.URLManager

  # Callbacks
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:expire_url, state) do
    # Reschedule once more
    schedule_work()
    URLManager.expire_urls()

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 2 hours (written in milliseconds).
    # Alternatively, one might write :timer.hours(2)
    Process.send_after(self(), :expire_url, :timer.seconds(20))
  end
end
