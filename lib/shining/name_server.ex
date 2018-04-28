defmodule Shining.NameServer do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(_opts) do
    # process registered as name_server
    GenServer.start_link(__MODULE__, :ok, name: :name_server)
  end

  def select_female() do
    GenServer.call(:name_server, :select_female)
  end

  def select_male() do
    GenServer.call(:name_server, :select_male)
  end

  ## Server Callbacks

  defp init_male_names(), do: File.read!("priv/words/engine/male_names.txt") |> String.split()
  defp init_female_names(), do: File.read!("priv/words/engine/female_names.txt") |> String.split()


  def init(:ok) do
    {:ok, %{
      female_names: init_female_names(),
      male_names: init_male_names()}
    }
  end

  def handle_call(:select_female, _from, names = %{female_names: female_names}) do
    {:reply, Enum.random(female_names), names}
  end

  def handle_call(:select_male, _from, names = %{male_names: male_names}) do
    {:reply, Enum.random(male_names), names}
  end
end
