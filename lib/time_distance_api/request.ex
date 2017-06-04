defmodule TimeDistanceApi.Request do
  defstruct [:origin_lat, :origin_lon, :dest_lat, :dest_lon]

  def valid?(r) do
    valid_lat?(r.origin_lat) and valid_lat?(r.dest_lat) and
    valid_lon?(r.origin_lon) and valid_lon?(r.dest_lon)
  end

  defp valid_lat?(value) do
    case Float.parse(value) do
      { lat, "" } -> lat >= -90 and lat <= 90
      _ -> false
    end
  end

  defp valid_lon?(value) do
    case Float.parse(value) do
      { lat, "" } -> lat >= -180 and lat <= 180
      _ -> false
    end
  end
end
