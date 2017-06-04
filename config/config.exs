use Mix.Config

config :time_distance_api,
  cowboy_port: 4000

config :logger, level: :info

config :time_distance_api, TimeDistanceApi.Adapters.GoogleDistanceMatrix,
  api_key:  "AIzaSyAs63CQqv9v46a1x0YrjOgZdMjeXCzlQzg",
  endpoint: "https://maps.googleapis.com/maps/api/distancematrix/json"

config :time_distance_api, TimeDistanceApi.Adapters.BingRoutes,
  api_key:  "Aux12gFGgwS72DEM8dl31gNLprHxFFCPrhyNgk3x9KRJLkSFlU38A7jrmTQBS7bZ",
  endpoint: "http://dev.virtualearth.net/REST/v1/Routes"

config :time_distance_api, TimeDistanceApi.FallbackChain,
  chain: [
    TimeDistanceApi.Adapters.GoogleDistanceMatrix,
    TimeDistanceApi.Adapters.BingRoutes,
  ]
