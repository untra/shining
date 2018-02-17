defmodule ShiningWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :shining,
                              module: ShiningWeb.Guardian,
                              error_handler: ShiningWeb.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
end