defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UrlShortenerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UrlShortenerWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/urls", UrlLive.Index, :index
    live "/urls/new", UrlLive.Index, :new
    live "/urls/:id/edit", UrlLive.Index, :edit

    live "/urls/:id", UrlLive.Show, :show
    live "/urls/:id/show/edit", UrlLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", UrlShortenerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: UrlShortenerWeb.Telemetry, ecto_repos: [UrlShortener.Repo]
    end
  end
end
