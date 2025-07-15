defmodule Plug.Swoosh.MailboxMCP.Server do
  @moduledoc """
  MCP server implementation for Swoosh mailbox access.
  
  This server provides tools to interact with Swoosh's local mailbox storage,
  allowing MCP clients to list, retrieve, and manage emails.
  
  ## Available Tools
  
  - `list_emails` - List all emails in the mailbox
  - `get_email` - Retrieve a specific email by Message-ID
  - `delete_email` - Delete a specific email by Message-ID
  - `clear_mailbox` - Delete all emails from the mailbox
  """
  
  use Hermes.Server,
    name: "Swoosh Mailbox MCP Server",
    version: "0.1.0",
    capabilities: [:tools]

  component Plug.Swoosh.MailboxMCP.Tools.ListEmails
  component Plug.Swoosh.MailboxMCP.Tools.GetEmail
  component Plug.Swoosh.MailboxMCP.Tools.DeleteEmail
  component Plug.Swoosh.MailboxMCP.Tools.ClearMailbox
end
