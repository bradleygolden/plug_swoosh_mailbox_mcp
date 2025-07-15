defmodule DemoAppWeb.Router do
  use DemoAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api", DemoAppWeb do
    pipe_through :api
  end

  scope "/test", DemoAppWeb do
    pipe_through :api
    
    post "/send-email", TestController, :send_test_email
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:demo_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DemoAppWeb.Telemetry
    end
    
    scope "/dev" do
      pipe_through :api  # Use :api pipeline for MCP JSON requests
      
      forward "/swoosh_mailbox/mcp", Plug.Swoosh.MailboxMCP
    end
  end
end
