defmodule Plug.Swoosh.MailboxMCP.Application do
  @moduledoc """
  Application supervisor for Plug.Swoosh.MailboxMCP.

  Starts the necessary processes for MCP server functionality:
  - Hermes server registry
  - MCP server with StreamableHTTP transport
  """

  use Application

  def start(_type, _args) do
    children = [
      Hermes.Server.Registry,
      {Plug.Swoosh.MailboxMCP.Server, transport: :streamable_http}
    ]

    opts = [strategy: :one_for_one, name: Plug.Swoosh.MailboxMCP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
