defmodule Plug.Swoosh.MailboxMCP do
  @moduledoc """
  A Plug that exposes Swoosh local mailbox data via MCP protocol.
  
  This plug can be mounted in Phoenix applications to provide MCP server
  functionality for accessing Swoosh mailbox data.
  
  ## Usage
  
  In your Phoenix router (use :api pipeline for JSON requests):
  
      scope "/dev" do
        pipe_through :api
        forward "/swoosh_mailbox/mcp", Plug.Swoosh.MailboxMCP
      end
  
  MCP clients can then connect to http://localhost:4000/dev/swoosh_mailbox/mcp
  """
  
  @behaviour Plug
  
  @impl Plug
  def init(opts) do
    opts = Keyword.put(opts, :server, Plug.Swoosh.MailboxMCP.Server)
    Hermes.Server.Transport.StreamableHTTP.Plug.init(opts)
  end
  
  @impl Plug
  def call(conn, opts) do
    Hermes.Server.Transport.StreamableHTTP.Plug.call(conn, opts)
  end
end
