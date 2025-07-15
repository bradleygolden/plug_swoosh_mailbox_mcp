# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **production-ready Elixir library** that provides a Phoenix Plug for exposing Swoosh local mailbox data via the Model Context Protocol (MCP). It enables AI agents to programmatically access and manage email data through HTTP endpoints.

## Development Commands

```bash
# Project setup
mix deps.get                    # Install dependencies
mix compile                     # Compile the project
mix format                      # Format code according to .formatter.exs

# Testing
mix test                        # Run all tests
mix test --stale                # Run only stale tests
mix test test/specific_test.exs # Run a specific test file

# Documentation
mix docs                        # Generate documentation
```

## Code Architecture

### Current Structure
- **Main Module**: `Plug.Swoosh.MailboxMCP` - Implements @behaviour Plug, delegates to Hermes StreamableHTTP.Plug
- **Application**: `Plug.Swoosh.MailboxMCP.Application` - Supervision tree with Hermes registry and MCP server
- **MCP Server**: `Plug.Swoosh.MailboxMCP.Server` - Uses Hermes.Server with StreamableHTTP transport
- **MCP Tools**: Four tools for mailbox operations:
  - `ListEmails` - List all emails with summaries
  - `GetEmail` - Retrieve full email by Message-ID
  - `DeleteEmail` - Delete specific email by Message-ID
  - `ClearMailbox` - Delete all emails from mailbox
- **Dependencies**: hermes_mcp (~> 0.12.1), swoosh (~> 1.19), plug (~> 1.14), ex_doc (dev only)

### Key Architecture Notes
- **Purpose**: Phoenix Plug that exposes Swoosh local mailbox via MCP protocol over HTTP
- **Integration**: Proper Plug behavior implementation with init/1 and call/2 callbacks
- **Transport**: Uses Hermes StreamableHTTP transport for MCP over HTTP
- **Storage**: Directly accesses `Swoosh.Adapters.Local.Storage.Memory` for email data
- **Tools**: Each tool implements `Hermes.Server.Component` with schema DSL and execute/2 function

### MCP Tools API
- **list_emails**: No parameters, returns array of email summaries with count
- **get_email**: Requires `id` parameter (Message-ID), returns full email details
- **delete_email**: Requires `id` parameter (Message-ID), removes email from storage
- **clear_mailbox**: No parameters, clears entire mailbox and returns deleted count

### Development Status
- **Implementation**: Complete and production-ready
- **Dependencies**: All configured for Hex publishing
- **Testing**: ExUnit configured, ready for test implementation
- **Documentation**: Comprehensive README with prerequisites and usage examples
- **Publishing**: Ready for Hex with proper mix.exs configuration, LICENSE, and documentation

## Project Requirements

- **Elixir Version**: ~> 1.18
- **Dependencies**: hermes_mcp, swoosh, plug, ex_doc (dev)
- **Swoosh Setup**: Requires Swoosh.Adapters.Local configured in host application
- **Phoenix Integration**: Designed to be mounted in Phoenix router

## Usage Integration

Users integrate this into their Phoenix applications by:
1. Adding dependency to mix.exs
2. Configuring Swoosh with Local adapter
3. Mounting plug in Phoenix router: `forward "/dev/mailbox/mcp", Plug.Swoosh.MailboxMCP`
4. Connecting AI agents to the MCP endpoint at configured path

## Publishing Ready

The library is ready for Hex publishing with:
- Proper package configuration in mix.exs
- MIT license included
- Comprehensive documentation
- Clean dependency management
- Production-ready code structure