defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"

  alias OmiChan.HttpClient
  alias OmiChan.Auth

  def refresh_token(token) do
    HttpClient.post(get_refresh_uri(), %{ refresh_token: token })
  end

  defp get_refresh_uri do
    "#{@base}/oauth/token/refresh"
  end

  def send_message(room_id, message) do
    token = Auth.get_refresh_token()
    HttpClient.post(get_message_uri(room_id), %{ text: message }, %{ refresh_token: token })
  end

  defp get_message_uri(room) do
    "#{@base}/v1/rooms/#{room}/messages/text"
  end
end
