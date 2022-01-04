defmodule OmiChan.Http do
  def post(uri, body) do
    response = HTTPoison.post(uri, body, %{ "Content-Type" => "application/json" })
    case response do
      {:ok, response} -> response
      {:error, reason} -> raise "Oh No!"
    end
  end
end
