defmodule ShiningWeb.Router do
  use ShiningWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug ShiningWeb.Guardian.AuthPipeline
  end

  scope "/api", ShiningWeb.Api do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", ShiningWeb.Api do
    pipe_through [:api, :api_auth]

    resources "/users", UserController, only: [:update, :show, :delete]
  end

  scope "/", ShiningWeb do
    pipe_through :browser # Use the default browser stack

    get "/", WorldController, :new

    resources "/worlds", WorldController, only: [:new, :create, :show]

    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
    resources "/characters", CharacterController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShiningWeb do
  #   pipe_through :api
  # end
end
