defmodule AWeb.PageController do
  use AWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
