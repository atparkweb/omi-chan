defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"

  alias OmiChan.HttpClient

  def refresh_token(token) do
    HttpClient.post("#{@base}/oauth/token/refresh", %{ refresh_token: token })
  end

  def send_message(message) do
    room = Dotenv.get("ROOM_ID")
    token = OmiChan.Auth.get_access_token()
    HttpClient.post("#{@base}/v1/rooms/#{room}/messages/text", %{ text: message }, %{ "Authorization" => "Bearer #{token}"})
  end
end
