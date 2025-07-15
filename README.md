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

First, you need to configure Swoosh to use the local adapter for development:

```elixir
# config/dev.exs
config :your_app, YourApp.Mailer,
  adapter: Swoosh.Adapters.Local
```

### 2. Set up Your Mailer

Create a mailer module in your application:

```elixir
# lib/your_app/mailer.ex
defmodule YourApp.Mailer do
  use Swoosh.Mailer, otp_app: :your_app
end
```

### 3. Add Dependencies

Make sure all required dependencies are in your mix.exs:

```elixir
# mix.exs
defp deps do
  [
    {:swoosh, "~> 1.19"},
    {:plug_swoosh_mailbox_mcp, "~> 0.1.0"}
  ]
end
```

## Usage

Mount the plug in your Phoenix router:

```elixir
# lib/your_app_web/router.ex
defmodule YourAppWeb.Router do
  use YourAppWeb, :router

  # In development scope
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser
      forward "/mailbox/mcp", Plug.Swoosh.MailboxMCP
    end
  end
end
```

Your MCP server will be available at `http://localhost:4000/dev/mailbox/mcp`.

### Testing with Sample Emails

To test the MCP server, send some emails using your configured mailer:

```elixir
# In your Phoenix application or IEx session
import Swoosh.Email

# Send a test email
email = new()
|> to("user@example.com")
|> from("admin@example.com")
|> subject("Test Email")
|> text_body("This is a test email for MCP server")

YourApp.Mailer.deliver(email)
```

The email will be stored in the local adapter and accessible via the MCP tools.

## MCP Tools

- **list_emails**: List all emails in the mailbox
- **get_email**: Retrieve a specific email by Message-ID
- **delete_email**: Delete a specific email by Message-ID
- **clear_mailbox**: Delete all emails from the mailbox

## Requirements

- Elixir ~> 1.18
- Phoenix application (for router integration)
- Swoosh configured with Local adapter
- Hermes MCP for MCP protocol support (automatically included)

## MCP Client Configuration

To connect MCP clients to your server, use the following configuration:

```json
{
  "mcpServers": {
    "swoosh-mailbox": {
      "command": "curl",
      "args": [
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", "@-",
        "http://localhost:4000/dev/mailbox/mcp"
      ]
    }
  }
}
```

Documentation can be found at <https://hexdocs.pm/plug_swoosh_mailbox_mcp>.
