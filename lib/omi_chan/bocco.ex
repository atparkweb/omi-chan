defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"
  @default_headers %{"Content-Type" => "application/json"}

  alias OmiChan.Auth

  def send_message(room_id, message) do
    {:ok, data} = post(get_message_uri(room_id), %{ text: message })
    data
  end

  defp add_auth_header(headers) do
    token = Auth.get_access_token()
    Map.merge(%{ "Authorization" => "Bearer #{token}" }, headers)
  end

  defp add_default_headers(headers) do
    Map.merge(@default_headers, headers)
  end

  defp get_message_uri(room) do
    "#{@base}/v1/rooms/#{room}/messages/text"
  end

  defp post(uri, data, headers \\ %{}) do
    headers = add_default_headers(headers) |> add_auth_header
    result = HTTPoison.post(uri, Poison.encode!(data), headers)
    case result do
      {:ok, %{ body: body }} -> {:ok, Poison.decode!(body)}
      {:error, reason} -> raise IO.inspect reason
    end
  end
end
