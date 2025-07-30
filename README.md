# BeamMCP

An Elixir implementation of an MCP (Model Context Protocol) server using the Hermes MCP library.

## Description

BeamMCP is a simple MCP server that demonstrates how to build AI-assistant integrations using Elixir. It currently provides:

- **Resources**: System information about the BEAM VM and runtime

## Installation

1. Clone this repository
2. Install dependencies:
   ```bash
   mix deps.get
   ```
3. Compile the project:
   ```bash
   mix compile
   ```

## Running the Server

The server uses STDIO transport by default. To run it:

```bash
mix run --no-halt
```

The server will listen on standard input/output for MCP protocol messages.

## Features

### Resources

- **system://info**: Returns BEAM VM and system information including:
  - BeamMCP version
  - Erlang/OTP version
  - Elixir version
  - Number of schedulers
  - Process count
  - Memory usage statistics (in bytes)

## Testing with MCP Clients

You can test this server with any MCP-compatible client. For example, using the Hermes MCP CLI:

```bash
# In another terminal, connect to the server
mix hermes.stdio.interactive --command="mix run --no-halt"
```

Then you can:
- List available resources: `list_resources`
- Read system info: `read_resource` with URI `system://info`

## Testing

Run the test suite with:

```bash
mix test
```

The tests use a custom `BeamMCP.MCPCase` framework based on Hermes MCP testing patterns that provides:
- MCP-specific assertions (`assert_mcp_response`, `assert_mcp_error`, etc.)
- Message builders for creating test requests
- Setup functions for common test scenarios
- Domain-specific testing utilities

Tests verify:
- Server configuration (name, version, capabilities)
- Resource reading functionality
- JSON response formatting
- Error handling with proper MCP error codes
- Protocol compliance

## Configuration

The server is configured in `lib/beam_mcp/application.ex` to start automatically with STDIO transport. You can modify this to use other transports like SSE (Server-Sent Events) if needed.