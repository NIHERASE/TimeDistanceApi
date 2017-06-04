defmodule TimeDistanceApi do
  @moduledoc """
  Documentation for TimeDistanceApi.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TimeDistanceApi.hello
      :world

  """
  def hello do
    :world
  end

  def calculate() do
    TimeDistanceApi.Adapters.GoogleMatrix.hello
  end
end
