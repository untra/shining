defmodule Shining.Engine.CharacterServer do
  alias Shining.Engine.{HexCoordinates, Character, Player}

  def start_link(character_name, %Character{} = character), do:
    GenServer.start_link(__MODULE__, character, name: via_tuple(character_name))

  def init(character) do
    {:ok, Character.init_statusquo(character)}
  end

  def via_tuple(character_name) do
    # TODO: fix this
    {:via, Registry, {Registry.Characters, "CHARACTER-#{character_name}"}}
  end

  # Character has a running timer
  def handle_cast(msg, %Character{fsmTimer: fsmTimer, fsmAnticipating: {newStage, _started}} = character) do
    # check the timer and cancel it
    case Process.cancel_timer(fsmTimer) do
      # timer expired! change the state, clear the timer and anticipating
      false -> handle_cast(msg, %{character | fsmTimer: nil, fsmAnticipating: nil})
      # not yet finished! pause the clock, downstream must handle the specifics TODO
      remaining -> handle_cast(msg, %{character | fsmTimer: nil, fsmAnticipating: {newStage, remaining}})
    end
  end

  def handle_cast({:anticipate, _details}, %Character{fsmAnticipating: {nextStage, time}} = character) do
    timer = Process.send_after(self(), {:setstage, nextStage}, character, time)
    {:noreply, %{character | fsmTimer: timer}}
  end

  def handle_cast({:setstage, nextStage}, %Character{fsmStage: currentStage} = character) do
    # notify frontend of stage change
    # init_stage(nextStage, character)
    {:noreply, %{character | fsmStage: nextStage}}
  end

  # automate this turn, if able
  # def init_stage(:ready, %Character{fsmAutomation: {:ready, automation})
  #   # some fuckin way to handle this
  # end

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

  def handle_cast({:character_death, details}, state) do
    {:noreply, state}
  end

  # returns the current character coordinates
  def handle_call(:current_position, _from, character) do
    {:reply, Character.currentPosition(character), character}
  end

  # returns the current character coordinates
  def handle_call(:current_area, _from, character) do
    {:reply, Character.currentArea(character), character}
  end

  # handle_info redirect to handle_cast, to enable Process.send_after
  def handle_info(msg, state) do
    handle_cast(msg, state)
  end

end
