defmodule AWeb.HeartbeatChannel do
  use Phoenix.Channel

  require Integer

  def join("heartbeat:listen", _, socket) do
    send(self(), {:beat, 0})
    {:ok, socket}
  end

  def handle_info({:beat, n}, socket) when Integer.is_even(n) do
    broadcast!(socket, "ping", %{ping: n})
    Process.send_after(self(), {:beat, n + 1}, 2000)
    {:noreply, socket}
  end

  def handle_info({:beat, n}, socket) do
    result =
      {:global, B.CodeChangeServer}
      |> GenServer.whereis()
      |> case do
        nil ->
          ""

        pid ->
          GenServer.cast(
            pid,
            {:concat,
             65..90
             |> Stream.map(
               &(&1
                 |> List.wrap()
                 |> List.to_string())
             )
             |> Enum.random()}
          )

          GenServer.call(pid, :state)
      end

    broadcast!(socket, "ping", %{ping: n, pong: result})
    Process.send_after(self(), {:beat, n + 1}, 2000)
    {:noreply, socket}
  end
end
