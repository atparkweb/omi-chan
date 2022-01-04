defmodule OmiChan.Bocco do
  @base "https://platform-api.bocco.me"

  def refresh_token do
    req_body = Poison.encode!(%{ refresh_token: "7f68b74b-33b6-426f-b87f-b5a6f10946a2" })
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
      {:error, _reason} -> raise "Oh No!"
    end
  end
end
