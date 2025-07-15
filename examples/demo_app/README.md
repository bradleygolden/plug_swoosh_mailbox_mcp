# Demo App for Plug.Swoosh.MailboxMCP

This is a minimal Phoenix application for testing the `plug_swoosh_mailbox_mcp` library.

## Setup

1. Install dependencies:
   ```bash
   mix deps.get
   ```

2. Start the server:
   ```bash
   mix phx.server
   ```

The server will be available at `http://localhost:4000` (or set a custom port with `PORT=4001 mix phx.server`).

## Testing the MCP Server

### 1. Send Test Emails

Send a test email to populate the mailbox:

```bash
curl -X POST http://localhost:4000/test/send-email
```

### 2. Test MCP Tools

The MCP server is available at `http://localhost:4000/dev/mailbox/mcp`.

Test the MCP tools with curl:

```bash
# List all emails
curl -X POST http://localhost:4000/dev/mailbox/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "list_emails",
      "arguments": {}
    }
  }'

# Get a specific email (replace MESSAGE_ID with actual Message-ID)
curl -X POST http://localhost:4000/dev/mailbox/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/call",
    "params": {
      "name": "get_email",
      "arguments": {
        "id": "MESSAGE_ID"
      }
    }
  }'

# Clear all emails
curl -X POST http://localhost:4000/dev/mailbox/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 3,
    "method": "tools/call",
    "params": {
      "name": "clear_mailbox",
      "arguments": {}
    }
  }'
```

## Features

- ✅ Phoenix app with Swoosh local adapter
- ✅ MCP server mounted at `/dev/mailbox/mcp`
- ✅ Test endpoint to send emails
- ✅ All 4 MCP tools working: list_emails, get_email, delete_email, clear_mailbox
- ✅ Uses local library path for testing before publishing
