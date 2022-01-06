defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"
  @default_headers [{"Content-Type", "application/json"}]

  alias OmiChan.Auth

  def send_message(_room, message) do
    client = Auth.get_oath_client()
    room = Dotenv.get("ROOM_ID")
    OAuth2.Client.post!(client, get_uri(:message, room), %{ text: message }, @default_headers)
    |> handle_response
  end

  defp handle_response(%{ status_code: 200, body: body}) do
    body
  end
  defp handle_response(error) do
    IO.puts "ERROR: HTTP response. #{inspect error}"
    %{}
  end

  defp get_uri(:message, room_id) do
    "#{@base}/v1/rooms/#{room_id}/messages/text"
  end
end
