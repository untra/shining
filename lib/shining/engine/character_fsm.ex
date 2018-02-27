defmodule Shining.Engine.CharacterFSM do
  alias Shining.Engine.{HexCoordinates, Character, Player}

  def start_link(character), do:
    GenServer.start_link(__MODULE__, character, name: via_tuple(character))

  def init(character) do
    {:ok, Character.init_statusquo(character)}
  end

  def via_tuple(character) do
    # TODO: fix this
    {:via, Registry, {Registry.Characters, "CHARACTER-"}}
  end

  # Character has a running timer
  def handle_cast(msg, %Character{fsmTimer: fsmTimer, fsmAnticipating: {newStage, _started}} = character) when !is_nil(fsmTimer) do
    # check the timer and cancel it
    case Process.cancel_timer(fsmTimer) do
      # timer expired! change the state, clear the timer and anticipating
      false -> handle_cast(msg, from, %{character | fsmTimer: nil, fsmAnticipating: nil})
      # not yet finished! pause the clock, downstream must handle the specifics
      remaining -> handle_cast(msg, from, %{character | fsmTimer: nil, fsmAnticipating: {newstage, remaining}})
    end
  end

  def handle_cast({:readying, _details}, %Character{fsmAnticipating: {nextStage, time}} = character) do
    timer = Process.send_after(self(), {:setstage, nextStage}, character, time)
    {:noreply, %{character | fsmTimer: timer}}
  end

  def handle_cast({:setstage, nextStage}, %Character{fsmStage: currentStage} = character) do
    {:noreply, %{character | fsmStage: nextStage}}
  end

  # taking damage
  def handle_cast({:take_damage, damage}, state) do
    {:noreply, state}
  end

  # taking healing
  def handle_cast({:take_healing, healing}, state) do
    {:noreply, state}
  end

  # taking some status effect change
  def handle_cast({:take_effect, effect}, state) do
    {:noreply, state}
  end

  # oh snap, the character died!
  def handle_cast({:character_death, details}, state) do
    {:noreply, state}
  end

  def handle_info(msg, state) do
    handle_cast(msg, state)
  end

end