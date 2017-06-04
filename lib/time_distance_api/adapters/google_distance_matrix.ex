defmodule TimeDistanceApi.Adapters.GoogleDistanceMatrix do
  def verify_configuration do
    api_key()
  end

  def calculate(%TimeDistanceApi.Request{} = request) do
    %{ body: body,
       status_code: 200
    } = HTTPoison.get!(construct_uri(request))
    { :ok, response } = Poison.decode(body)
    parse_response(response)
  end

  defp parse_response(response) do
    %{ "status" => "OK",
       "rows"   => [%{"elements" => [element]}]
    } = response

    case element do
      %{ "distance" => %{"value" => distance},
         "duration" => %{"value" => duration},
         "status"   => "OK" } ->
        { :ok, %TimeDistanceApi.Result{ duration: duration, distance: distance } }
      %{ "status" => "ZERO_RESULTS" } ->
        { :error, :no_route }
      %{ "status" => "MAX_ROUTE_LENGTH_EXCEEDED" } ->
        { :error, :no_route }
      _ ->
        raise("Could not parse #{inspect(response)}")
    end
  end

  defp construct_uri(req) do
    query = URI.encode_query(%{
      units:        "metric",
      origins:      "#{req.origin_lat},#{req.origin_lon}",
      destinations: "#{req.dest_lat},#{req.dest_lon}",
      key:          api_key()
    })
    to_string URI.merge(endpoint(), "?#{query}")
  end

  defp endpoint do
    "https://maps.googleapis.com/maps/api/distancematrix/json"
  end

  defp api_key do
    config = Application.fetch_env!(:time_distance_api, __MODULE__)
    config[:api_key] || raise("API key missing")
  end
end
