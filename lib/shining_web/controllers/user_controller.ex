defmodule ShiningWeb.UserController do
  use ShiningWeb, :controller

  alias Shining.Accounts
  alias Shining.Accounts.User

  action_fallback ShiningWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, params) do
    # Find the user in the database based on the credentials sent with the request
    # login_cred = %{password: "nope"}
    # with %User{} = user <- Accounts.find(params.username) do
    #   # Attempt to authenticate the user
    #   with {:ok, token, _claims} <- Accounts.authenticate(%{user: user, password: login_cred.password}) do
    #     # Render the token
    #     render conn, "token.json", token: token
    #   end
    # end
    {:error, :notImplemented}
  end
end
