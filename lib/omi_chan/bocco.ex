defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"

  alias OmiChan.HttpClient
  alias OmiChan.Auth

  def refresh_token(token) do
    HttpClient.post(get_uri(:refresh), %{ refresh_token: token })
  end

  def send_message(_room, message) do
    # temp test
    room = Dotenv.get("ROOM_ID")

    HttpClient.post(get_uri(:message, room), %{ text: message }, get_auth_header())
  end

  defp get_auth_header do
    token = Auth.get_access_token()
    %{ "Authorization" => "Bearer #{token}" }
  end

  defp get_uri(:refresh) do
    "#{@base}/oauth/token/refresh"
  end
  defp get_uri(:message, room_id) do
    "#{@base}/v1/rooms/#{room_id}/messages/text"
  end
end
