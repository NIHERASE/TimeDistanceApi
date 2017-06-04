defmodule TimeDistanceApi.Api.V1 do
  def process_request(params) do
    case parse_request(params) do
      { :ok, request } ->
        case TimeDistanceApi.FallbackChain.execute(request) do
          { :ok,    response }  -> { 200, response }
          { :error, :no_route } -> { 200, %{ error: "no_route" } }
          { :error, :internal}  -> { 500, %{ error: "internal_error" } }
        end
      { :error, reason } -> { 400, %{ error: reason } }
    end
  end

  defp parse_request(params) do
    case params do
      %{ "origin_lat" => origin_lat, "origin_lon" => origin_lon, "dest_lat" => dest_lat, "dest_lon" => dest_lon} ->
        request = %TimeDistanceApi.Request{origin_lat: origin_lat, origin_lon: origin_lon, dest_lat: dest_lat, dest_lon: dest_lon}
        { :ok, request }
      _ ->
        { :error, :malformed_request }
    end
  end
end
