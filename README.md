# Plug.Swoosh.MailboxMCP

A Plug that exposes Swoosh local mailbox data via the Model Context Protocol (MCP), enabling AI agents to access email data programmatically through HTTP endpoints.

## Installation

Add `plug_swoosh_mailbox_mcp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_swoosh_mailbox_mcp, "~> 0.1.0"}
  ]
end
```

## Prerequisites

### 1. Configure Swoosh with Local Adapter

```elixir
# config/dev.exs
config :your_app, YourApp.Mailer,
  adapter: Swoosh.Adapters.Local
```

### 2. Set up Your Mailer

```elixir
defmodule YourApp.Mailer do
  use Swoosh.Mailer, otp_app: :your_app
end
```

### 3. Add Dependencies & HTTP Client

Swoosh requires an HTTP client. Choose one of the supported clients:

```elixir
# mix.exs
defp deps do
  [
    {:swoosh, "~> 1.19"},
    {:plug_swoosh_mailbox_mcp, "~> 0.1.0"},

    # Choose one HTTP client (required by Swoosh):
    {:hackney, "~> 1.9"},        # Default HTTP client
    # OR {:finch, "~> 0.13"},    # Alternative HTTP client
    # OR {:req, "~> 0.3"}        # Alternative HTTP client
  ]
end
```

### 4. Configure HTTP Client (Optional)

By default, Swoosh uses Hackney. To use a different HTTP client:

```elixir
# config/config.exs
config :swoosh, :api_client, Swoosh.ApiClient.Finch  # For Finch
# OR
config :swoosh, :api_client, Swoosh.ApiClient.Req    # For Req
```

**Note:** The Local adapter used for development doesn't require an HTTP client, but Swoosh itself requires one to be available.

## Usage

Mount the plug in your Phoenix router:

```elixir
defmodule YourAppWeb.Router do
  use YourAppWeb, :router

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser
      forward "/mailbox/mcp", Plug.Swoosh.MailboxMCP
    end
  end
end
```

Your MCP server will be available at `http://localhost:4000/dev/mailbox/mcp`.

## Development & Testing

A complete example Phoenix application is available in the `examples/demo_app` directory for testing the library locally before publishing.

### Running the Example

```bash
cd examples/demo_app
mix deps.get
mix phx.server
```

The example app includes:
- Pre-configured Swoosh local adapter
- MCP server mounted at `/dev/mailbox/mcp`
- Test endpoint to send sample emails
- Complete testing instructions

See `examples/demo_app/README.md` for detailed testing instructions.

Documentation can be found at <https://hexdocs.pm/plug_swoosh_mailbox_mcp>.
