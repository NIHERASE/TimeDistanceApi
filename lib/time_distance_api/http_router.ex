defmodule TimeDistanceApi.HTTPRouter do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]

  plug :match
  plug :dispatch

  get "/api/v1/get_time_distance" do
    { code, response_map } = TimeDistanceApi.Api.V1.process_request(conn.params)
    json_resp(conn, code, response_map)
  end

  match _, do: json_resp(conn, 404, %{ error: "no api here" })

  defp json_resp(conn, code, map) do
    { :ok, json } = Poison.encode(map)
    send_resp(conn, code, json)
  end
end
