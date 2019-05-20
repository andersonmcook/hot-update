defmodule AWeb.HeartbeatChannel do
  use Phoenix.Channel

  def join("heartbeat:listen", _, socket) do
    send(self(), {:beat, 0})
    {:ok, socket}
  end

  def handle_info({:beat, n}, socket) do
    broadcast!(socket, "ping", %{ping: n})
    Process.send_after(self(), {:beat, n + 1}, 2000)
    {:noreply, socket}
  end
end
