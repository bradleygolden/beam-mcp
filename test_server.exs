#!/usr/bin/env elixir
# Simple test script for the MCP server

IO.puts("Testing BeamMCP Server...")
IO.puts("======================")

# Start the application
{:ok, _} = Application.ensure_all_started(:beam_mcp)

# Give it a moment to start
Process.sleep(1000)

IO.puts("\nServer started successfully!")
IO.puts("\nTo test the server:")
IO.puts("1. Run: mix run --no-halt")
IO.puts("2. The server will listen on STDIO for MCP protocol messages")
IO.puts("3. Use an MCP client to connect and test the following:")
IO.puts("   - Tool: 'calculate' with operations: add, subtract, multiply, divide")
IO.puts("   - Resource: 'system://info' for system information")
IO.puts("   - Prompt: 'greeting' with name and optional style parameters")
IO.puts("\nPress Ctrl+C to stop the server.")

# Keep the script running
Process.sleep(:infinity)