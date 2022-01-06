defmodule OmiChan.Bocco do
  @default_headers [{"Content-Type", "application/json"}]

  alias OmiChan.Auth

  def send_message(_room, message) do
    client = Auth.get_oath_client()
    room = Dotenv.get("ROOM_ID")
    OAuth2.Client.post!(client, "/v1/rooms/#{room}/messages/text", %{ text: message }, @default_headers)
    |> handle_response
  end

  defp handle_response(%{ status_code: 200, body: body}) do
    body
  end
  defp handle_response(error) do
    IO.puts "ERROR: HTTP response. #{inspect error}"
    %{}
  end
end
