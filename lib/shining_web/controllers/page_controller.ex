defmodule ShiningWeb.PageController do
  use ShiningWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
