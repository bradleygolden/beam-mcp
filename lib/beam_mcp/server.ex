defmodule BeamMCP.Server do
  use Hermes.Server,
    name: "BeamMCP Server",
    version: "0.1.0",
    capabilities: [:tools, :resources, :prompts]

  @impl true
  def handle_tool_call("calculate", args, frame) do
    result = case args do
      %{"operation" => "add", "a" => a, "b" => b} -> 
        {:ok, %{result: a + b}}
      %{"operation" => "subtract", "a" => a, "b" => b} -> 
        {:ok, %{result: a - b}}
      %{"operation" => "multiply", "a" => a, "b" => b} -> 
        {:ok, %{result: a * b}}
      %{"operation" => "divide", "a" => a, "b" => b} when b != 0 -> 
        {:ok, %{result: a / b}}
      %{"operation" => "divide", "a" => _, "b" => 0} -> 
        {:error, "Division by zero"}
      _ -> 
        {:error, "Invalid operation or parameters"}
    end

    case result do
      {:ok, data} -> {:reply, data, frame}
      {:error, msg} -> {:error, %{code: -32603, message: msg}, frame}
    end
  end

  @impl true
  def handle_resource_read("system://info", frame) do
    info = %{
      erlang_version: :erlang.system_info(:otp_release) |> to_string(),
      elixir_version: System.version(),
      schedulers: :erlang.system_info(:schedulers),
      process_count: :erlang.system_info(:process_count),
      uptime_ms: :erlang.statistics(:wall_clock) |> elem(0),
      memory: %{
        total: :erlang.memory(:total),
        processes: :erlang.memory(:processes),
        atom: :erlang.memory(:atom),
        binary: :erlang.memory(:binary),
        ets: :erlang.memory(:ets)
      }
    }

    {:reply, %{content: Jason.encode!(info, pretty: true), mimeType: "application/json"}, frame}
  end

  @impl true
  def handle_prompt_get("greeting", args, frame) do
    name = Map.get(args, "name", "friend")
    style = Map.get(args, "style", "casual")
    
    messages = case style do
      "formal" -> [
        %{
          role: "user",
          content: "Please generate a formal greeting for #{name}. Be respectful and professional."
        }
      ]
      
      "enthusiastic" -> [
        %{
          role: "user",
          content: "Generate an enthusiastic and energetic greeting for #{name}! Make it exciting!"
        }
      ]
      
      _ -> [
        %{
          role: "user",
          content: "Create a friendly, casual greeting for #{name}."
        }
      ]
    end

    {:reply, %{messages: messages}, frame}
  end
end