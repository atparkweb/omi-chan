defmodule OmiChan.HttpClient do
  @default_headers %{"Content-Type" => "application/json"}

  def post(uri, data, headers \\ %{}) do
    HTTPoison.post(uri, Poison.encode!(data), add_default_headers(headers))
    |> handle_response
  end

  defp add_default_headers(headers) do
    Map.merge(@default_headers, headers)
  end

  defp handle_response({:ok, response}) do
    %{ body: body } = response
    Poison.decode!(body)
  end
  defp handle_response({:error, reason}) do
    IO.puts "ERROR: HTTP response. #{inspect reason}"
    %{}
  end
end
