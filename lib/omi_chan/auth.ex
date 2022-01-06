defmodule OmiChan.Auth do
  use GenServer

  @name :auth_server

  defmodule AuthState do
    defstruct oauth2_client: nil
  end

  def start do
    GenServer.start(__MODULE__, %AuthState{}, name: @name)
  end

  @impl true
  def init(state) do
    client = init_oauth_client()
    initial_state = %{ state | oauth2_client: client}
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_oauth_client, _from, state) do
    {:reply, state.oauth2_client, state}
  end

  def init_oauth_client do
    client = OAuth2.Client.new([
      strategy: OAuth2.Strategy.Refresh,
      client_id: Dotenv.get("CLIENT_ID"),
      client_secret: Dotenv.get("CLIENT_SECRET"),
      site: "https://platform-api.bocco.me",
      params: %{"refresh_token" => Dotenv.get("REFRESH_TOKEN")}
    ])

    OAuth2.Client.put_serializer(client, "application/json", Poison)

    client
  end

  def get_oath_client do
    GenServer.call @name, :get_oauth_client
  end
end
