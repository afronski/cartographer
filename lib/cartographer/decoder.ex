defmodule Cartographer.Decoder do
  @moduledoc """
  Cartographer.Decoder is a module which provides way to decode geohash into
  geocoordinates, with given precision.

  It uses a finite alphabet for reading geocoordinates from a human readable form.
  """

  @min_lat -90
  @max_lat +90

  @min_lng -180
  @max_lng +180

  @doc """
  Decodes provided geohash (as `geohash`), which uses standard `base32` alphabet
  into pair of latitude and longitude. Keep in mind that the less amount of characters
  the bigger error will be.

       iex> Cartographer.Decoder.from_geohash("0")
       {-67.5, -157.5}

       iex> Cartographer.Decoder.from_geohash("ezs42")
       {42.6, -5.6}
  """
  def from_geohash(geohash, precision \\ 1) do
    bits = Cartographer.to_bits(geohash)

    bits_for_lat = _filter_bits(bits, fn({_, i}) -> rem(i, 2) != 0 end)
    bits_for_lng = _filter_bits(bits, fn({_, i}) -> rem(i, 2) == 0 end)

    {_decode(bits_for_lat, @min_lat, @max_lat, precision), _decode(bits_for_lng, @min_lng, @max_lng, precision)}
  end

  defp _filter_bits(bits, index_filter) do
    (for <<x::size(1) <- bits>>, do: x)
    |> Enum.with_index
    |> Enum.filter(index_filter)
    |> Enum.map(fn({bit, _}) -> bit end)
  end

  defp _round(number, precision) do
    p = :math.pow(10, precision)
    round(number * p) / p
  end

  defp _decode([], min, max, precision) do
    _round(min(max, max(min, (min + max) / 2.0)), precision)
  end

  defp _decode([ 0 | rest], min, max, precision) do
    center = (min + max) / 2
    _decode(rest, min, center, precision)
  end

  defp _decode([ 1 | rest], min, max, precision) do
    center = (min + max) / 2
    _decode(rest, center, max, precision)
  end
end
