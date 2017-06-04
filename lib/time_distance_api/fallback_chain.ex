require Logger

defmodule TimeDistanceApi.FallbackChain do
  def execute(request) do
    execute_chain(chain(), request)
  end

  defp execute_chain([], _request) do
    { :error, :internal }
  end
  defp execute_chain([module | rest], request) do
    case run_with_module(module, request) do
      nil -> execute_chain(rest, request)
      response -> response
    end
  end

  defp run_with_module(module, request) do
    try do
      apply(module, :execute!, [request])
    rescue
      e in RuntimeError ->
        Logger.error("FallbackChain encountered an error when running #{module}: #{inspect(e)}")
        nil
    end
  end

  defp chain do
    config()[:chain] || raise("Chain is not set")
  end

  defp config do
    Application.fetch_env!(:time_distance_api, __MODULE__)
  end
end
