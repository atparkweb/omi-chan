defmodule OmiChan.Auth do
  use GenServer

  @name :auth_server

  alias OmiChan.Bocco

  defmodule AuthState do
    defstruct refresh_token: nil,
      access_token: nil
  end

  def start do
    oauth_init()
    refresh = Dotenv.get("REFRESH_TOKEN")
    GenServer.start(__MODULE__, %AuthState{refresh_token: refresh}, name: @name)
  end

  @impl true
  def init(state) do
    Process.send(self(), :refresh, [])
    {:ok, state}
  end

  @impl true
  def handle_call(:get_refresh_token, _from, state) do
    {:reply, state.refresh_token, state}
  end
  def handle_call(:get_access_token, _from, state) do
    {:reply, state.access_token, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    IO.puts "Refreshing token..."
    %{ "access_token" => access, "refresh_token" => refresh } = refresh_tokens(state.refresh_token)
    new_state = %{ state | access_token: access, refresh_token: refresh }
    {:noreply, new_state}
  end
  def handle_info(unexpected, state) do
    IO.puts "Unexpected message! #{unexpected}"
    {:noreply, state}
  end

  def oauth_init do
    token = get_refresh_token()
    client = OAuth2.Client.new([
      strategy: OAuth2.Strategy.Refresh,
      client_id: Dotenv.get("CLIENT_ID"),
      client_secret: Dotenv.get("CLIENT_SECRET"),
      site: "https://platform-api.bocco.me",
      params: %{"refresh_token" => token}
    ])
    OAuth2.Client.put_serializer(client, "application/json", Poison)
  end

  def refresh_tokens(token) do
    Task.async(fn -> Bocco.refresh_token(token) end)
    |> Task.await
  end

  def get_refresh_token do
    GenServer.call @name, :get_refresh_token
  end

  def get_access_token do
    GenServer.call @name, :get_access_token
  end

  def refresh do
    GenServer.call @name, :refresh_tokens
  end
end
