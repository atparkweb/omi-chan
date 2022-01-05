defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"

  def refresh_token(token) do
    req_body = Poison.encode!(%{ refresh_token: token })
    %{ body: body } = post(get_refresh_uri(), req_body)
    body = Poison.decode!(body)
    body
  end

  defp get_refresh_uri do
    "#{@base}/oauth/token/refresh"
  end

  defp post(uri, body) do
    response = HTTPoison.post(uri, body, %{ "Content-Type" => "application/json" })
    case response do
      {:ok, response} -> response
      {:error, reason} -> raise "Oh No! #{inspect reason}"
    end
  end
end
