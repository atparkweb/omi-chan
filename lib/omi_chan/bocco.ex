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
    {:ok, data} = post(get_message_uri(room_id), %{ text: message }, %{}, [with_auth: true])
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
    headers = add_default_headers(headers)
    result = HTTPoison.post(uri, Poison.encode!(data), headers)
    case result do
      {:ok, %{ body: body }} -> {:ok, Poison.decode!(body)}
      {:error, reason} -> raise IO.inspect reason
    end
  end
  defp post(uri, data, headers, [with_auth: true]) do
    post(uri, data, add_auth_header(headers))
  end
end
