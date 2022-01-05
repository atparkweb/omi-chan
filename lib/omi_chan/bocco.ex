defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"
  @default_headers %{"Content-Type" => "application/json"}

  alias OmiChan.Auth

  def refresh_token(token) do
    {:ok, data} = post(get_refresh_uri(), %{ refresh_token: token })
    data
  end

  defp get_refresh_uri do
    "#{@base}/oauth/token/refresh"
  end

  def send_message(room_id, message) do
    token = Auth.get_access_token()
    auth_header = %{ "Authorization" => "Bearer #{token}" }
    {:ok, data} = post(get_message_uri(room_id), %{ text: message }, auth_header)
    data
  end

  defp get_message_uri(room) do
    "#{@base}/v1/rooms/#{room}/messages/text"
  end

  defp post(uri, data, headers \\ %{}) do
    result = HTTPoison.post(uri, Poison.encode!(data), Map.merge(@default_headers, headers))
    case result do
      {:ok, %{ body: body }} -> {:ok, Poison.decode!(body)}
      {:error, reason} -> raise IO.inspect reason
    end
  end
end
