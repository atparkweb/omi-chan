defmodule OmiChan.Api.Auth do
  use GenServer

  @name :auth_server

  alias OmiChan.Api.Bocco

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
    tokens = get_tokens()
    initial_state = %{ state | access_token: tokens.access_token, refresh_token: tokens.refresh_token }
    # schedule refresh
    {:ok, initial_state}
  end

  def get_tokens do
    response = Task.async(fn -> Bocco.refresh_token end)
      |> Task.await
  end
end
