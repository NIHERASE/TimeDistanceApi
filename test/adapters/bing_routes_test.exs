defmodule TimeDistanceApi.Adapters.BingRoutesTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest TimeDistanceApi.Adapters.BingRoutes

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes/bing_routes")
    :ok
  end

  test "Returns TimeDistanceApi.Result" do
    use_cassette "success" do
      request = %TimeDistanceApi.Request{
        origin_lat: 55.776451,
        origin_lon: 37.655212,
        dest_lat: 55.757399,
        dest_lon: 37.660853
      }
      response = TimeDistanceApi.Adapters.BingRoutes.execute!(request)
      assert response == {:ok, %TimeDistanceApi.Result{distance: 5128.0, duration: 640}}
    end
  end

  test "Returns error no route if no route is available" do
    use_cassette "no_route" do
      request = %TimeDistanceApi.Request{
        origin_lat: 0.0,
        origin_lon: 0.0,
        dest_lat: 80.0,
        dest_lon: 170.0
      }
      response = TimeDistanceApi.Adapters.BingRoutes.execute!(request)
      assert response == {:error, :no_route}
    end
  end
end
