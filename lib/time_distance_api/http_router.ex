# defmodule TimeDistanceApi.HTTPRouter do
#   import Plug.Conn
#
#   def init(options), do: options
#
#   def call(conn, _opts) do
#     conn
#     |> put_resp_content_type("text/plain")
#     |> send_resp(200, "Hello World!")
#   end
# end

require Logger

# defmodule TimeDistanceApi.HTTPRouter do
#   use Plug.Router
#   use Plug.ErrorHandler
#
#   plug :match
#   plug :dispatch
#   plug Plug.Parsers, parsers: [:json],
#                      pass: ["application/json"],
#                      json_decoder: Poison
#
#   get "/api/v1/get_time_distance" do
#     send_resp(conn, 200, "world")
#   end
# #
#   match _ do
#     send_resp(conn, 404, "")
#   end
#
  # defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
  #   Logger.error "Error!!"
  #   send_resp(conn, conn.status, "Something went wrong")
  # end
# end

require IEx

defmodule TimeDistanceApi.HTTPRouter do
  use Plug.Router

  # alias TimeDistanceApi.Plug.VerifyRequest

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  # plug VerifyRequest, fields: ["content", "mimetype"],
                      # paths:  ["/upload"]

  plug :match
  plug :dispatch

  get "/api/v1/get_time_distance" do
    { code, response_map } = TimeDistanceApi.Api.V1.process_request(conn.params)
    json_resp(conn, code, response_map)
  end

  match _, do: send_resp(conn, 404, "Oops!")

  defp json_resp(conn, code, map) do
    { :ok, json } = Poison.encode(map)
    send_resp(conn, code, json)
  end
end
