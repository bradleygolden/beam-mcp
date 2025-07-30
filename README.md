# BeamMCP

An Elixir implementation of an MCP (Model Context Protocol) server using the Hermes MCP library.

## Description

BeamMCP is a simple MCP server that demonstrates how to build AI-assistant integrations using Elixir. It provides:

- **Tools**: A calculator tool for basic arithmetic operations
- **Resources**: System information about the BEAM VM and runtime
- **Prompts**: Customizable greeting prompts with different styles

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

### Tools

- **calculate**: Performs arithmetic operations
  - Parameters:
    - `operation`: "add", "subtract", "multiply", or "divide"
    - `a`: First number
    - `b`: Second number

### Resources

- **system://info**: Returns BEAM VM and system information including:
  - Erlang/OTP version
  - Elixir version
  - Number of schedulers
  - Process count
  - Memory usage statistics

### Prompts

- **greeting**: Generates greeting messages
  - Parameters:
    - `name`: The name to greet (required)
    - `style`: "formal", "casual", or "enthusiastic" (optional)

## Testing with MCP Clients

You can test this server with any MCP-compatible client. For example, using the Hermes MCP CLI:

```bash
# In another terminal, connect to the server
mix hermes.stdio.interactive --command="mix run --no-halt"
```

Then you can:
- List available tools: `list_tools`
- Call the calculator: `call_tool` then enter tool name and arguments
- Read system info: `read_resource` with URI `system://info`
- Get a greeting prompt: `get_prompt` with name "greeting"

## Configuration

The server is configured in `lib/beam_mcp/application.ex` to start automatically with STDIO transport. You can modify this to use other transports like SSE (Server-Sent Events) if needed.

