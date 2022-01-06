defmodule OmiChan.HttpClient do
  def post(uri, data, headers \\ %{}) do
    headers = Map.merge(%{"Content-Type" => "application/json"}, headers)
    HTTPoison.post(uri, Poison.encode!(data), headers)
    |> handle_response
  end

  defp handle_response({:ok, response}) do
    %{ body: body } = response
    Poison.decode!(body)
  end
  defp handle_response({:error, reason}) do
    IO.puts "ERROR: #{inspect reason}"
  end
end
