defmodule OmiChan.Auth do
  use GenServer

  @name :auth_server

  alias OmiChan.Bocco

  defmodule AuthState do
    defstruct refresh_token: "",
      access_token: "",
      interval: :timer.minutes(60) # token expires after 1 hour
  end

  def start do
    IO.puts "Starting auth server..."
    GenServer.start(__MODULE__, %AuthState{}, name: @name)
  end

  @impl true
  def init(state) do
    %{ "access_token" => access, "refresh_token" => refresh } = get_tokens()
    initial_state = %{ state | access_token: access, refresh_token: refresh }
    schedule_refresh(state.interval)
    {:ok, state}
  end

  @impl true
  def handle_call(:get_token, _from, state) do
    {:reply, state.refresh_token, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    IO.puts "Refreshing token..."
    %{ "access_token" => access, "refresh_token" => refresh } = get_tokens()
    IO.puts "Access: #{access}, Refresh: #{refresh}"
    new_state = %{ state | access_token: access, refresh_token: refresh }
    schedule_refresh(state.interval)
    {:noreply, new_state}
  end
  def handle_info(unexpected, state) do
    IO.puts "Unexpected message! #{unexpected}"
    {:noreply, state}
  end

  defp get_tokens do
    Task.async(fn -> Bocco.refresh_token() end)
      |> Task.await
  end

  defp get_refresh_token do
    GenServer.call @name, :get_refresh_token
  end

  defp schedule_refresh(time_in_ms) do
    Process.send_after(self(), :refresh, time_in_ms)
  end
end
