defmodule UrlShortener.Worker.ExpireUrls do
  use GenServer
  import Ecto.Query, warn: false
  alias UrlShortener.Repo
  alias UrlShortener.Base.Url
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
    expire_urls()

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 2 hours (written in milliseconds).
    # Alternatively, one might write :timer.hours(2)
    Process.send_after(self(), :expire_url, :timer.seconds(20))
  end

  defp expire_urls do
    datetime_now = DateTime.utc_now()

    from(u in Url,
      where:
        fragment("(? AT TIME ZONE 'UTC')::date + interval '1 month'", u.inserted_at) <
          ^datetime_now
    )
    |> Repo.update_all(set: [deleted: true, expired_date: datetime_now])
  end
end
