defmodule OmiChan.HttpClient do
  @default_headers %{"Content-Type" => "application/json"}

  def add_default_headers(headers) do
    Map.merge(@default_headers, headers)
  end

  def post(uri, data, headers \\ %{}) do
    headers = add_default_headers(headers)
    result = HTTPoison.post(uri, Poison.encode!(data), headers)
    case result do
      {:ok, %{ body: body }} -> {:ok, Poison.decode!(body)}
      {:error, reason} -> raise IO.inspect reason
    end
  end
end
