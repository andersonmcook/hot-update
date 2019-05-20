defmodule B.CodeChangeServer do
  use GenServer

  @vsn 1.0

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: {:global, __MODULE__})
  end

  def concat("") do
    :ok
  end

  def concat(str) when is_binary(str) do
    GenServer.cast({:global, __MODULE__}, {:concat, str})
  end

  def state do
    GenServer.call({:global, __MODULE__}, :state)
  end

  # Server
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:concat, str}, "") do
    {:noreply, str}
  end

  def handle_cast({:concat, str}, state) do
    {:noreply, state <> "." <> str}
  end

  def handle_call(:state, _, state) do
    {:reply, state, state}
  end

  def code_change(1.0, state, _extra) do
    {:ok, String.split(state, ".")}
  end
end

# defmodule B.CodeChangeServer do
#   use GenServer

#   @vsn 2.0

#   # Client
#   def start_link(_) do
#     GenServer.start_link(__MODULE__, [], name: __MODULE__)
#   end

#   def concat("") do
#     :ok
#   end

#   def concat(str) when is_binary(str) do
#     GenServer.cast(__MODULE__, {:concat, str})
#   end

#   def state do
#     GenServer.call(__MODULE__, :state)
#   end

#   # Server
#   def init(state) do
#     {:ok, state}
#   end

#   def handle_cast({:concat, str}, []) do
#     {:noreply, [str]}
#   end

#   def handle_cast({:concat, str}, state) do
#     {:noreply, state ++ [str]}
#   end

#   def handle_call(:state, _, state) do
#     {:reply, state, state}
#   end

#   def code_change(1.0, state, _extra) do
#     {:ok, String.split(state, ".")}
#   end
# end
