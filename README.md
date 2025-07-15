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

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :api requests
      forward "/swoosh_mailbox/mcp", Plug.Swoosh.MailboxMCP
    end
  end
end
```

Your MCP server will be available at `http://localhost:4000/dev/swoosh_mailbox/mcp`.

### Using with Swoosh MailboxPreview

If you're also using `Plug.Swoosh.MailboxPreview` (the HTML preview), use separate scopes with different pipelines:

```elixir
if Mix.env() == :dev do
  # HTML preview
  scope "/dev" do
    pipe_through :browser
    forward "/mailbox", Plug.Swoosh.MailboxPreview
  end

  # MCP server (JSON API)
  scope "/dev" do
    pipe_through :api
    forward "/swoosh_mailbox/mcp", Plug.Swoosh.MailboxMCP
  end
end
```

This gives you:
- **Swoosh Preview**: `http://localhost:4000/dev/mailbox` (HTML interface)
- **MCP Server**: `http://localhost:4000/dev/swoosh_mailbox/mcp` (JSON API)

## MCP Client Configuration

To connect MCP clients to your server, you'll need to install `mcp-proxy` and add this configuration to your MCP client settings:

1. **Install mcp-proxy**: Follow the installation instructions at <https://github.com/tidewave-ai/mcp_proxy_rust#installation>

2. **Add to your MCP client configuration**:

```json
{
  "mcpServers": {
    "swoosh_mailbox": {
      "command": "mcp-proxy",
      "args": [
        "http://localhost:4000/dev/swoosh_mailbox/mcp",
        "--transport=streamablehttp"
      ]
    }
  }
}
```

This configuration uses `mcp-proxy` to connect to your HTTP-based MCP server via the StreamableHTTP transport.

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
