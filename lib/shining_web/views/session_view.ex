defmodule ShiningWeb.SessionView do
  use ShiningWeb, :view

  def current_world_url(conn) do
    url(conn) <> conn.request_path
  end

  def ws_url do
    System.get_env("WS_URL") || ShiningWeb.Endpoint.config(:ws_url)
  end

end
