defmodule TimeDistanceApi.Adapters.BingRoutes do
  def execute!(%TimeDistanceApi.Request{} = request) do
    case HTTPoison.get!(construct_uri(request)) do
      %{ body: body, status_code: 200 } ->
        { :ok, response } = Poison.decode(body)
        parse_response(response)
      %{ status_code: 404 } ->
        { :error, :no_route }
      %{ status_code: 400 } ->
        { :error, :no_route }
      response ->
        raise("Could not parse #{inspect(response)}")
    end
  end

  defp parse_response(response) do
    %{
      "statusDescription" => "OK",
      "resourceSets" => [%{
        "resources" => [%{
          "travelDistance" => distance_km,
          "travelDuration" => duration
        }]
      }]
    } = response
    distance = Float.ceil(distance_km * 1000)
    { :ok, %TimeDistanceApi.Result{ duration: duration, distance: distance } }
  end

  defp construct_uri(req) do
    query = URI.encode_query(%{
      "wayPoint.1"      => "#{req.origin_lat},#{req.origin_lon}",
      "wayPoint.2"      => "#{req.dest_lat},#{req.dest_lon}",
      "distanceUnit"    => "km",
      "routeAttributes" => "routeSummariesOnly",
      "maxSolutions"    => 1,
      "key"             => api_key()
    })
    to_string URI.merge(endpoint(), "?#{query}")
  end

  defp config do
    Application.fetch_env!(:time_distance_api, __MODULE__)
  end

  defp api_key do
    config()[:api_key] || raise("API key missing")
  end

  defp endpoint do
    config()[:endpoint] || raise("Endpoint missing")
  end
end
